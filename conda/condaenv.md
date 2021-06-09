# NoobQuant conda environments

Instruction on how to install custom `conda` environments. Tailored for my own data science workflow. Tested installation on Windows machine.

First we need to install either `Anaconda` or `Miniconda`. Anaconda comes with a loaded `base` conda environment, whereas Miniconda does not.

 - Anaconda distributions can be do installed from [here](https://repo.anaconda.com/archive/).
   - When installing, check "add to path"(although it is not recommended). Window paths added are
     - *~/Anaconda3*
     - *~/Anaconda3/Library/mingw-w64/bin*
     - *~/Anaconda3/Library/usr/bin*
     - *~/Anaconda3/Library/bin*
     - *~/Anaconda3/Scripts*
   - Uncheck "Register Anaconda3 as my default Python". We don't want to use Python in `base` conda as our default.
- Miniconda distributions can be do installed from [here](https://repo.anaconda.com/miniconda/).

## Installing environments with Anaconda

First, check that there are no previous specification files haunting in Windows folder paths. Typical suspects outside *Anaconda/* folder are
 - Anconda related
    - C:\Users\<my_user_name>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Anaconda3 (64-bit)
 - Jupyter related
   - C:\Users\<my_user_name>\.jupyter
   - C:\Users\<my_user_name>\.ipynb_checkpoints
   - C:\Users\<my_user_name>\.ipython
   - C:\ProgramData\jupyter
   - C:\Users\<my_user_name>\AppData\Roaming\jupyter
 - conda related
   - C:\Users\<my_user_name>\.conda
 - Python packages related
   - C:\Users\<my_user_name>\.matplotlib
   - C:\Users\<my_user_name>\.keras
   - etc.
 - Windows environment variables: remove all Anaconda related
 - All R related stuff, if you don't want a standalone R installation beside the one in custom conda environments

Next, download version *2020.02-Windows-x86_64* of Anaconda.

Next, install [mamba](https://github.com/TheSnakePit/mamba) in the `base` conda environment and later on replace `conda` commands with `mamba` for speed:

```conda install mamba -c conda-forge```.

Now install custom environment(s). Tested specifications are:
 - `dev_2018`: Year 2018 version with Python 3.6.10 and R 3.6.0
 - `dev_2021`: Year 2021 version with Python 3.8.5 and R 3.6.3

Run creation commands as detailed below in specific sub-sections.

Finally, specify unique names for the Jupyter kernel specifications. This is done because we want to have multiple IPython/IR kernels for different conda environments (see [here](https://ipython.readthedocs.io/en/stable/install/kernel_install.html)). Run (depending on environemnt name)

```
conda activate dev2021
python -m ipykernel install --user --name dev2021_py --display-name "dev2021_py"
R
IRkernel::installspec(name='dev2021_r', displayname='dev2021_r')
quit()
```

This should add two folders kernels under user folder, e.g. *C:\Users\<myusername>\AppData\Roaming\jupyter\kernels*. Check that the folders are created!

Finally, run test files to see everything works:
 - python.py (e.g. in VSCode)
 - python.ipynb (in VSCode and Jupyter)
 - R.R (in RStudio installed with environment)
 - R.ipynb (in Jupyter)

See more in section *Using NoobQuant conda environments* below.

### dev_2018: Year 2018 version with Python 3.6.10 and R 3.6.0

```
mamba create --name dev anaconda python=3.6 numpy=1.16.4 numpy-base=1.16.4 tzlocal=2.0.0 pandas=0.25.0 seaborn=0.11.0
conda activate dev
mamba install -c r r=3.6.0 r-base=3.6.0 r-essentials=3.6.0 r-tidyverse=1.2.1 rtools=3.4.0 r-rjsdmx=2.1_0 r-seasonal=1.7.0 r-wavelets=0.3_0.1 rstudio=1.1.456
mamba install rpy2==2.9.4
```

### dev_2021: Year 2021 version with Python 3.8.5 and R 3.6.3

```
mamba create --name dev2021 anaconda=2020.11 rpy2=3.4.2 r-base=3.6.3 r-essentials=3.6 rtools=3.4.0 r-rjsdmx=2.1_0 r-seasonal=1.8.1 r-wavelets=0.3_0.1
```

**Notes about dev_2021**
 - Problem with *rstudio*; version 1.1.456 currently available in conda seems too old. Cannot install RStudio to this environment. MIght be able to use a standalone installation of RStudio and connect it to this R installation? At least cannot use one from different conda environment (trying to change used R will crash and prevent RStudio from launching again).

### Notes about installing environments

- Once environment is ready, one could export environment into construction files that can be used later to spin up the environment. However, building environments from these files does not usually work on different machines (dunno why).
  - (*OS unspecific*): Export *dev* environment to .yml ```conda env export --no-builds > nq_dev_py36_r36.yml``` (why *--no-builds* see [here](https://github.com/ContinuumIO/anaconda-issues/issues/9480)). Remove explicit prefix from end. Then build environment later by ```conda env create --file nq_dev_py36_r36.yml```.
  - (*OS specific*): Export *dev* environment to .txt ```conda list --explicit > nq_dev_py36_r36.txt```. Then build enviroment later by ```conda env create --name dev --file nq_dev_py36_r36.txt```. If error raised try removing line "@EXPLICIT" from the file.

## Using NoobQuant conda environments

**General tips and troublehsoot**

- If Jupyter kernel dying/restarting when running rpy2 commands, the reason might be that `R HOME` path is not set and rpy2 does not find the R installation that came with the environment. In this case we need to add it for this particular Python kernel:
  - Find the *kernel.json* for Python Jupyter kernel (e.g. *jupyter/dev2021_py/kernel.json*)
  - Add ```"env": {"R_HOME":"/home/your/anaconda3/envs/my-env-name/lib/R"}```, see [this](https://stackoverflow.com/a/60869259/7037299). ALso helpful might be [this](https://stackoverflow.com/questions/39347782/getting-segmentation-fault-core-dumped-error-while-importing-robjects-from-rpy2/53639407#53639407).
- When running Python/R instance, make sure
   - Python exe is *~/Anaconda3/envs/<env_name>/python.exe*
   - Python *sys.path* includes *~/Anaconda3/envs/dev~* and not other possible library paths
   - R exe is *~/Anaconda3/envs/<env_name>/lib/R/bin/x64/R*: ```file.path(R.home("bin"), "R")```
   - R ```.libPaths()``` contains only *~/Anaconda3/envs/dev/lib/R/library* and no other paths.

**Using Python and R in notebooks in Jupyter**

Python and R kernels of *dev* **should** be accessible in Jupyter when run from *base* environment when explicitly made so, see [here](https://ipython.readthedocs.io/en/stable/install/kernel_install.html) under *"you can make your IPython kernel in one env available to Jupyter in a different env"*. However, I have run to all kinds of problems with the R kernel, e.g. [this](https://github.com/IRkernel/IRkernel/issues/309), [this](https://github.com/jupyter/jupyter/issues/353), and R installation not being found when called from Python instance with *rpy2*. Thus, I have found it easier to use Python and R in Jupyter from *dev* environment. This is why jupyter is also installed in custom environment and not just in `base` as usually suggested (see e.g. discussion [here](https://stackoverflow.com/a/39623487/7037299)). This means whenever I launch Jupyter I make sure to do this from custom environment (e.g. ```conda activate dev2021; jupyter lab```).

**Using Python and R in VSCode**

Sometimes one might need to reinstall VSCode after new Anaconda installation, as VSCode might not be able to find kernel paths correctly. Firt, load VSCode extensions `Python` and `R`.

- **Python**: Make sure the desired custom environment (e.g. `dev2021`) Python interpreter is selected. Then from the *.py* file, right-clock and *Run Python file in terminal*. This creates a new Python terminal and executes the file. One can also *Run selection/line in Python terminal* to run specific section, in which case the Python terminal jumps into Python and can run/type single commands in the terminal. ```quit()``` to close the Python connection back to terminal. One can also run file/section of it in interactive terminal, in which case VSCode launches Jupyter to create the interactive window. I would however not recommend this too much, rather use notebooks for interactive computing.
- **R**: Cannot get this to work; seems like VSCode does not find my *dev* R installation even though ```r.rterm.windows``` explicitly set. Maybe because R is not in PATH Variable...
  - Beside `R` extension, make sure R LSP Client
  - Full instructions [in this video](https://www.youtube.com/watch?v=INP-FsluDuk&t).
- **Python notebooks**: Make sure that VSCode launches Jupyter instance by from desired custom conda environment (by default VScode launches Jupyter from `base`). Two ways to do this:
  - Make sure we can run *conda* commands from powershell terminal by running in Anaconda terminal ```conda init powershell``` (see [here](https://stackoverflow.com/questions/47800794/how-to-activate-different-anaconda-environment-from-powershell/54811138)). Then open powershell terminal in VSCode, run ```conda activate dev```. Then make sure that both selected Python interpreter and interpreter for Jupyter is is Python from *dev*. Now start up a Python notebook and things should work. See more [here](https://medium.com/analytics-vidhya/working-on-jupyter-notebooks-in-vs-code-from-virtual-conda-environment-f415726e329d).
  - Start jupyter from *dev* in separate Anaconda promt and in VSCode select Python interpreter from the Jupyter url that was launched. 
- **R notebooks**: Not yet possible, but coming: see [here](https://github.com/Microsoft/vscode-python/issues/5078).

**Using R in RStudio**
Launch RStudio from conda promt ```rstudio```. 

## Addig packages to environments

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

It is also possible to use manual *setup.py* installation and it should be enough to just activate the environment: ```conda activate dev; python /path/to/mypackage/setup.py install```, or replace *install* with *develop*. See [here)](https://stackoverflow.com/questions/26556865/anaconda-equivalent-of-setup-py-develop). Sometime it might help to put commad directory to the clodec package folder.

Some R packages/their correct version are not available via ```conda install```. In this case we can R ```install.packages()```. Make the installation into specific folder where to store separate R packages (e.g. if there is standalone R installation put to libpath of that, or some other folder).
- If possible, install needed dependencies of the package via conda first.
- Make sure conda *dev* R lib path *~/Anaconda3/envs/dev/lib/R/library* comes before any other R lib path (e.g. the standalone R lib path).<br>```.libPaths(new=c("<my_custom_path>/<env_name>/Lib/R/library", .libPaths()))```<br>
- When using R insallation of a package try first without installing dependencies, as we try to include them via conda. If this fails or dependencies installed via conda have wrong versions available, let R installation install also dependencies. That is: First try <br>```install.packages("mylib", lib="some_R_lib_path", dependencies = FALSE)()))```<br>
If it does not work, try<br>```install.packages("mylib", lib="some_R_lib_path", dependencies = TRUE)```.


## Useful links
 - https://stackoverflow.com/questions/38066873/create-anaconda-python-environment-with-all-packages
 - https://towardsdatascience.com/a-guide-to-conda-environments-bc6180fc533
 - https://community.rstudio.com/t/why-not-r-via-conda/9438/3
 - https://medium.com/analytics-vidhya/working-on-jupyter-notebooks-in-vs-code-from-virtual-conda-environment-f415726e329d
 - https://www.anaconda.com/blog/moving-conda-environments
