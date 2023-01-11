# How to add a snippet here from a vsix file

Unzip the vsix and extract the package.json and its snippets files

Either modify package.json here so it adds to the `contributes` list, or add a
new folder and `load` it in the `from_vscode` section of `init.lua`
