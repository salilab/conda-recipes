# Add missing ProjectReference sections
import sys

fname = sys.argv[1]

contents = open(fname).read()

if 'cblas' in fname:
    contents = contents.replace('</Project>', """
  <ItemGroup>
    <ProjectReference Include="..\copy_gsl_headers\copy_gsl_headers.vcxproj">
      <Project>{69c1e5cd-84bc-40f0-b357-4f0e917e65b7}</Project>
      <ReferenceOutputAssembly>false</ReferenceOutputAssembly>
    </ProjectReference>
  </ItemGroup>
</Project>""")
else:
    contents = contents.replace('</Project>', """
  <ItemGroup>
    <ProjectReference Include="..\copy_gsl_headers\copy_gsl_headers.vcxproj">
      <Project>{69c1e5cd-84bc-40f0-b357-4f0e917e65b7}</Project>
      <ReferenceOutputAssembly>false</ReferenceOutputAssembly>
    </ProjectReference>
    <ProjectReference Include="..\libgslcblas\libgslcblas.vcxproj">
      <Project>{f12c72b9-a7c8-4fe1-8ca7-00b06819033a}</Project>
      <ReferenceOutputAssembly>false</ReferenceOutputAssembly>
    </ProjectReference>
  </ItemGroup>
</Project>""")

open(fname, 'w').write(contents)
