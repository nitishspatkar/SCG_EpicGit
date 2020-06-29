# Towards bringing requirements and development closer

This project provides a practical solution for IDE-integrated requirements engineering. Work in progress - expect frequent changes.

## How to Load

Run this code snippet in the playground of Pharo 8.0 and you will have access to the code.
```
Metacello new
  baseline: 'Epic';
  repository: 'github://rniem379349/SCG_EpicGit';
  load
```

## Getting Started
Type in the following code in the Playground and run it:
```
EpicExamples new requirementContainerWithThreeEpics.
```
Navigate through the different views in the container element to see the representations of the requirements artifacts within.
