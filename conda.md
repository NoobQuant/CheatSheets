# CONDA CHEAT SHEET

## Basics

### List packages
```conda list```

### List environments
```conda info --envs```

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

## NoobQuant conda environment (Python 3.6.10 and R 3.6.0)

### Installing

Tested on Windows machine and Anaconda3 distribution *2020.02-Windows-x86_64*.
 - Download Anaconda from [here](https://repo.anaconda.com/archive/) and install it (checked "add to path" although not recommended). Paths added
   - *~/Anaconda3*
   - *~/Anaconda3/Library/mingw-w64/bin*
   - *~/Anaconda3/Library/usr/bin*
   - *~/Anaconda3/Library/bin*
   - *~/Anaconda3/Scripts*
 - (optional) Install [mamba](https://github.com/TheSnakePit/mamba) and later on replace ```conda``` commands with ```mamba``` for speed: ```conda install mamba -c conda-forge``` 
 - Install *dev* environemnt by running creation commands in section *Environment creation*


 - Register Jupyter kernels for to be used from *base*. This should add kernels under user folder, e.g. *C:\Users\<myusername>\AppData\Roaming\jupyter\kernels*

```
conda activate dev
python -m ipykernel install --user --name dev --display-name "dev py"
R
IRkernel::installspec()
quit()
```

### Constructing environment

The *dev* environment is constructed as follows:
  - Download Anaconda3 installation *2020.02-Windows-x86_64* and install it (archive of Anaconda installations can be found [here](https://repo.anaconda.com/archive/)). This generates the base conda environment (containing e.g. Jupyter).
  - Create new environment *dev* by commands
```
mamba create --name dev anaconda python=3.6 numpy=1.16.4 numpy-base=1.16.4 tzlocal=2.0.0 pandas=0.25.0 seaborn=0.11.0
conda activate dev
mamba install -c r r=3.6.0 r-base=3.6.0 r-essentials=3.6.0 r-tidyverse=1.2.1 rtools=3.4.0 r-rjsdmx=2.1_0 r-seasonal=1.7.0 r-wavelets=0.3_0.1 rstudio=1.1.456
mamba install rpy2==2.9.4
```

  - Environment is now ready.
    - One could at this point export environment into construction files that can be used later to spin up the environment. However, building environments from these files does not usually work on different machines (dunno why).
      - (*OS unspecific*): Export *dev* environment to .yml ```conda env export --no-builds > nq_dev_py36_r36.yml``` (why *--no-builds* see [here](https://github.com/ContinuumIO/anaconda-issues/issues/9480)). Remove explicit prefix from end. Then build environment later by ```conda env create --file nq_dev_py36_r36.yml```.
      - (*OS specific*): Export *dev* environment to .txt ```conda list --explicit > nq_dev_py36_r36.txt```. Then build enviroment later by ```conda env create --name dev --file nq_dev_py36_r36.txt```. If error raised try removing line "@EXPLICIT" from the file.


### Using

 - When running either Python and R instance, make sure
   - Python exe is *~/Anaconda3/envs/dev/python.exe*
   - R exe is *~/Anaconda3/envs/temp/lib/R/bin/x64/R*
   - Python *sys.path* includes *~/Anaconda3/envs/dev~* and not other possible library paths
   - R ```.libPaths()``` contains only *~/Anaconda3/envs/dev/lib/R/library* and no other paths.
 - **Using Python and R in Jupyter Lab/Notebook**
   - Python and R kernels of *dev* **should** be accessible in Jupyter when run from *base* environment. However, I have run to all kinds of problems with the R kernel, e.g. [this](https://github.com/IRkernel/IRkernel/issues/309), [this](https://github.com/jupyter/jupyter/issues/353), and R installation not being found when called from Python instance with *rpy2*.
   - Thus I have found it easier to use Python and R in Jupyter from *dev* environment. **This is why jupyter is also installed in *dev* and not just in *base* as usually suggested** (see e.g. discussion [here](https://stackoverflow.com/a/39623487/7037299)). This means whenever I launch Jupyter I make sure to do this from *dev* environment (e.g. ```conda activate dev; jupyter lab```).
 - **Using Python and R in VSCode**.
   - Sometimes one might need to reinstall VSCode after new Anaconda installation, as VSCode might not be able to find kernel paths correctly.
   - Load extensions *Python* and *R*.
   - **Python**: Make sure *dev* Python interpreter is selected. Then from .py file, *Run Python file in terminal* creates a new Python terminal and executes the file. One can also *Run selection/line in Python terminal* to run specific section, in which case the Python terminal jumps into Python and can run/type single commands in the terminal. ```quit()``` to close the Python connection back to terminal. One can also run file/section of it in interactive terminal, in which case VSCode launches Jupyter to create the interactive window. I would however not recommend this too much, rather just run notebooks if desire for interactive computing.
   - **R**: Cannot get this to work; seems like VSCode does not find my *dev* R installation even though ```r.rterm.windows``` explicitly set. Probably because R is not in PATH Variable...
   - **Python notebooks**: By default when VScode launches Jupyter it does it from *base*. If Python and R kernels in *dev* work from *base* and rpy2 finds the R installation in Jupyter then this is fine. But it might be the case that (see above) rpy2 cannot find R installation in *dev*. In this case we need to make sure that VSCode launches Jupyter instance by from *dev*. Two ways to do this:
     - Make sure we can run *conda* commands from powershell terminal by running in Anaconda terminal ```conda init powershell``` (see [here](https://stackoverflow.com/questions/47800794/how-to-activate-different-anaconda-environment-from-powershell/54811138)). Then open powershell terminal in VSCode, run ```conda activate dev```. Then make sure that both selected Python interpreter and interpreter for Jupyter is is Python from *dev*. Now start up a Python notebook and things should work. See more [here](https://medium.com/analytics-vidhya/working-on-jupyter-notebooks-in-vs-code-from-virtual-conda-environment-f415726e329d).
     - Start jupyter from *dev* in separate Anaconda promt and in VSCode select Python interpreter from the Jupyter url that was launched. 
   - **R notebooks**: Not yet possible, but coming: see [here](https://github.com/Microsoft/vscode-python/issues/5078).
- **Using R in RStudio**: launch RStudio from conda promt ```rstudio```. 

### Addig packages
Try installing via conda first.

```
conda activate <env_name>
conda install <pckg_name>
```

Python packages tend to be well available via conda install. However, if desired package is not, one can also install via pip to the conda enviroment; just make sure you are using pip installed to the conda env, not the global one! If this does not happen automatically (v1), then use correct pip explicitly (v2). See [here](https://stackoverflow.com/a/43729857) and [here](http://know.continuum.io/rs/387-XNW-688/images/conda-cheatsheet.pdf).

*v1*
```
conda activate <env_name>
pip install <pckg_name>
```

*v2*
```
conda activate <env_name>
conda install pip #if not done before
<path_to_env>/bin/pip install <pckg_name>
```

Some R packages/their correct version are not available via ```conda install```. In this case we can R ```install.packages()```. Make the installation into specific folder where to store separate R packages (e.g. if there is standalone R installation put to libpath of that, or some other folder).
- If possible, install needed dependencies of the package via conda first.
- Make sure conda *dev* R lib path *~/Anaconda3/envs/dev/lib/R/library* comes before any other R lib path (e.g. the standalone R lib path).<br>```.libPaths(new=c("<my_custom_path>/<env_name>/Lib/R/library", .libPaths()))```<br>
- When using R insallation of a package try first without installing dependencies, as we try to include them via conda. If this fails or dependencies installed via conda have wrong versions available, let R installation install also dependencies. That is: First try <br>```install.packages("mylib", lib="some_R_lib_path", dependencies = FALSE)()))```<br>
If it does not work, try<br>```install.packages("mylib", lib="some_R_lib_path", dependencies = TRUE)```.

   

### Other useful links
 - https://stackoverflow.com/questions/38066873/create-anaconda-python-environment-with-all-packages
 - https://towardsdatascience.com/a-guide-to-conda-environments-bc6180fc533
 - https://community.rstudio.com/t/why-not-r-via-conda/9438/3
 - https://medium.com/analytics-vidhya/working-on-jupyter-notebooks-in-vs-code-from-virtual-conda-environment-f415726e329d
 - https://www.anaconda.com/blog/moving-conda-environments
