# Microsoft Reporting Services Projects

MSBuild targets to build [SSRS report projects](https://marketplace.visualstudio.com/items?itemName=ProBITools.MicrosoftReportProjectsforVisualStudio)


### Example use in a multi-stage build

```
FROM christianacca/ssrs-projects:1.21 AS msbuild-ssrs
FROM microsoft/dotnet-framework-build:4.7.1

COPY --from=msbuild-ssrs ["C:/MSBuild/Reporting Services/", "C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools/MSBuild/Reporting Services/"]
```