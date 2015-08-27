#include <stdio.h>
#include <windows.h>
#include <string.h>
#include <stdlib.h>

/*
   Wrapper for modXXX command line tool.
   The modXXX binary is designed to be run from within a command prompt that
   has the MODINSTALLXXX and PYTHONPATH variables set. We can't rely on these
   being set appropriately in an Anaconda installation, so we provide this
   little wrapper that sets them appropriately and then passes control to
   the 'real' modXXX executable.

   It does:
   - Set MODINSTALLXXX to <ourpath>\Library\modeller
   - Set PYTHONHOME to <ourpath>\Library\modeller\modlib
   - Pass execution to <ourpath>\Library\modeller\modXXX-orig
   where <ourpath> is the directory the wrapper is installed in.

   Compile with
      cl mod_wrapper.c shell32.lib
   then copy the resulting mod_wrapper.exe to modXXX.exe and install in
   the top-level Anaconda directory.
*/


/* Set Python environment variables */
static void set_python_env(const char *topdir)
{
  char *new_path;
  const char *subdir = "\\Library\\modeller\\modlib";
  new_path = malloc(strlen(topdir) + strlen(subdir) + 12);
  strcpy(new_path, "PYTHONHOME=");
  strcat(new_path, topdir);
  strcat(new_path, subdir);
  /*printf("%s\n", new_path);*/
  putenv(new_path);
  /* Don't free new_path; it is now part of the environment */
}

/* Set Modeller environment variables */
static void set_modeller_env(const char *topdir, const char *version)
{
  char *new_path, *ch;
  const char *subdir = "\\Library\\modeller";
  new_path = malloc(strlen(topdir) + strlen(subdir) + strlen(version) + 12);
  strcpy(new_path, "MODINSTALL");
  strcat(new_path, version);
  // replace . with v
  ch = strchr(new_path, '.');
  if (ch) {
    *ch = 'v';
  }
  strcat(new_path, "=");
  strcat(new_path, topdir);
  strcat(new_path, subdir);
  /*printf("%s\n", new_path);*/
  putenv(new_path);
  /* Don't free new_path; it is now part of the environment */
}

/* Get full path to real Modeller binary */
static char *get_new_full_path(const char *topdir, const char *version)
{
  const char *subdir = "\\Library\\modeller\\modlib\\mod";
  char *newpath = malloc(strlen(topdir) + strlen(subdir) + strlen(version)
                         + 10);
  strcpy(newpath, topdir);
  strcat(newpath, subdir);
  strcat(newpath, version);
  strcat(newpath, "-orig.exe");
  return newpath;
}

/* Get path and version number of this binary */
static void get_path_and_version(char **dir, char **version)
{
  char path[MAX_PATH * 2];
  size_t l;
  char *ch;
  DWORD ret = GetModuleFileName(NULL, path, MAX_PATH * 2);
  if (ret == 0) {
    fprintf(stderr, "Failed to get executable name, code %d\n", GetLastError());
    exit(1);
  }
  l = strlen(path);
  if (l > 4 && path[l - 4] == '.') {
    /* Remove extension */
    path[l-4] = '\0';
  }
  ch = strrchr(path, '\\');
  if (ch && strlen(ch + 1) > 4) {
    *ch = '\0';
    *version = strdup(ch + 4); /* Skip past "mod" prefix */
  } else {
    fprintf(stderr, "Could not determine Modeller version\n");
    exit(1);
  }
  *dir = strdup(path);
}

/* Find where the parameters start in the command line (skip past the
   executable name) */
static char *find_param_start(char *cmdline)
{
  BOOL in_quote = FALSE, in_space = FALSE;
  for (; *cmdline; cmdline++) {
    /* Ignore spaces that are quoted */
    if (*cmdline == ' ' && !in_quote) {
      in_space = TRUE;
    } else if (*cmdline == '"') {
      in_quote = !in_quote;
    }
    /* Return the first nonspace that follows a space */
    if (in_space && *cmdline != ' ') {
      break;
    }
  }
  return cmdline;
}

/* Convert original parameters into those that python.exe wants (i.e. prepend
   the name of the Python script) */
static char *make_python_parameters(const char *orig_param, const char *binary)
{
  char *param = malloc(strlen(orig_param) + strlen(binary) + 4);
  strcpy(param, "\"");
  strcat(param, binary);
  strcat(param, "\" ");
  strcat(param, orig_param);
  /*printf("python param %s\n", param);*/
  return param;
}

/* Get the full path to the Anaconda Python. */
static char* get_python_binary(const char *topdir)
{
  char *python = malloc(strlen(topdir) + 12);
  strcpy(python, topdir);
  strcat(python, "\\python.exe");
  return python;
}

/* Run the given binary, passing it the parameters we ourselves were given. */
static DWORD run_binary(const char *binary)
{
  SHELLEXECUTEINFO si;
  BOOL bResult;
  char *param;
  param = strdup(GetCommandLine());

  ZeroMemory(&si, sizeof(SHELLEXECUTEINFO));
  si.cbSize = sizeof(SHELLEXECUTEINFO);
  /* Wait for the spawned process to finish, so that any output goes to the
     console *before* the next command prompt */
  si.fMask = SEE_MASK_NO_CONSOLE | SEE_MASK_NOASYNC | SEE_MASK_NOCLOSEPROCESS;
  si.lpFile = binary;
  si.lpParameters = find_param_start(param);
  si.nShow = SW_SHOWNA;
  bResult = ShellExecuteEx(&si);
  free(param);

  if (bResult) {
    if (si.hProcess) {
      DWORD exit_code;
      WaitForSingleObject(si.hProcess, INFINITE);
      GetExitCodeProcess(si.hProcess, &exit_code);
      CloseHandle(si.hProcess);
      return exit_code;
    }
  } else {
    fprintf(stderr, "Failed to start process, code %d\n", GetLastError());
    exit(1);
  }
  return 0;
}

int main(int argc, char *argv[]) {
  char *dir, *version, *new_full_path;
  DWORD return_code;

  get_path_and_version(&dir, &version);
  /*printf("dir, version %s, %s\n", dir, version);*/
  set_python_env(dir);
  set_modeller_env(dir, version);
  new_full_path = get_new_full_path(dir, version);
  /*printf("new full path %s\n", new_full_path);*/
  return_code = run_binary(new_full_path);
  free(dir);
  free(version);
  free(new_full_path);
  return return_code;
}
