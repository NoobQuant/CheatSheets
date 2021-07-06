# CONDA CHEAT SHEET

## Basics

### List packages
```conda list```

### Search for a package
```conda search -f <pckg_name>```

### List environments
```conda info --envs```

### conda channels

```conda config --add channels <channel_name>```

```conda config --show channels```

## Environments

### Create new environment (simple)
```conda create my_env_name```

### Create new environment with custom path and python version
```
conda config --append envs_dirs my_custom_path # make sure custom location is discoverable for conda
conda create --prefix=my_custom_path\my_env_name python=3.6.7
```

### Create new environment with default anaconda packages
```conda create --prefix=my_custom_path\my_env_name anaconda```

### Create new environment from yml file
```conda env create -f environment.yml```

### Remove environment
```conda env remove --name env_name```

### Clone existing environment
```conda create --name <new_env> --clone <old_env>```

## Meta-stuff (e.g. Anaconda)

### Anaconda promt to right-click menu
https://gist.github.com/jiewpeng/8ba446acf329b1801bf91db767d179ea

## Jupyter related commands

### List paths
```jupyter --paths```

### List kernels
```jupyter kernelspec list```

