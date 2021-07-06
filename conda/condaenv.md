# NoobQuant `conda` data science environments

## Introduction

This article is my "cook book recipe" on how to build tailored `conda` environments for everyday Python/R data science work. The article covers

 - how to install the environments containing fresh Python and R installations
 - how to install packages to environments 
 - how to run Python and R instances, separately or together, in Jupyter Lab, VSCode, or RStudio.

The instructions are written for a **Windows 10 machine**. They might be applicable to other operating systems as well, but no guarantees are made.

## Why tailored conda environments for Python/R data science work?

Python and R are great tools for data science. The internet is full of arguments which one is better, but my answer is: why not use both? There are huge benefits in being able to flexibly change between the two, as each has their own advantages. 

Python is great for example for machine learning and writing infrastructure around the data science worklfow, while R offers a much broader set in statistical tools. The goal is to have at disposal an environment for exploratative data science, where one can do the data wrangling with the tool one is more comfortable with, and employ the best parts from the other tool on the fly.

With NoobQuant `conda` environments one can for example
 - Run Python in VSCode or Jupyter Lab
 - Run R in RStudio or Jupyter Lab
 - Call R code from within Python
 - Use typical Python data science packages such as pandas, scikit learn, matplotlib etc.
 - Use typical R data science packages such as tidyverse, ggplot2 etc.

## When not to use NoobQuant `conda` environments?

If you are solely using R. If you are afaraid of tinkerting. FILL IN REST!

## What are Anaconda, `conda`, and `conda` environments?
 
Anaconda is a software distribution for data science work. `conda` is the package manager for Anaconda. conda environments are... FILL IN REST!

conda environments: base and custom envs.. FILL IN REST!

## Installing tailored `conda` environments

### Download and install Anaconda

First we need to install either Anaconda. One could also download a stripped version of Anaconda, called Miniconda, but in this article we are working with Anaconda. Anaconda distributions can be do installed from [here](https://repo.anaconda.com/archive/). Miniconda distributions can be do installed from [here](https://repo.anaconda.com/miniconda/).

**\<optional\>**

If there have been previous Anaconda installations, check that no previous specification files are haunting in directories. Typical suspects outside *Anaconda/* folder are:

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

**\</optional\>**

In this version of the article we use Anaconda version *2020.02-Windows-x86_64*. Downlaod and run the installer. Install the software to preferred path. When installing, uncheck *"Register Anaconda3 as my default Python"* (we don't want to use Python in `base` environment as our default). Also check the *"add to path"* checkbox (although it is not recommended. Following window paths added are
  - *~/Anaconda3*
  - *~/Anaconda3/Library/mingw-w64/bin*
  - *~/Anaconda3/Library/usr/bin*
  - *~/Anaconda3/Library/bin*
  - *~/Anaconda3/Scripts*

### Installing environments

Open Anaconda promt, where most commands below will be given. We start by telling `conda` to add a few extra channels to the list where to look for packages: *conda-forge* and *r*. Python packages tend to be faster available in *conda-forge* than in default channels. *r* is needed fot R packages.

```
conda config --add channels conda-forge
conda config --add channels r
```

Next, install [mamba](https://github.com/TheSnakePit/mamba) in the `base` conda environment. Later we'll replace `conda` commands with `mamba` for increased speed:

```
conda install mamba
```

Now we install the custom environment(s). There are two tested specifications which and either of them can be installed. One can also install both, but make sure to complete the installation fully for one before starting with another.

 - `dev_2018`: Year 2018 version with Python 3.6.10 and R 3.6.0
 - `dev_2021`: Year 2021 version with Python 3.8.5 and R 3.6.3

To create the environment, run command for desired environent as detailed in next two subsections.

#### dev_2018: Year 2018 version with Python 3.6.10 and R 3.6.0

```
mamba create --name dev2018 anaconda python=3.6 numpy=1.16.4 numpy-base=1.16.4 tzlocal=2.0.0 pandas=0.25.0 seaborn=0.11.0 rpy2==2.9.4 r=3.6.0 r-base=3.6.0 r-essentials=3.6.0 r-tidyverse=1.2.1 rtools=3.4.0 r-rjsdmx=2.1_0 r-seasonal=1.7.0 rstudio=1.1.456
```

#### dev_2021: Year 2021 version with Python 3.8.5 and R 3.6.3**

```
mamba create --name dev2021 anaconda=2020.11 rpy2=3.4.2 r-base=3.6.3 r-essentials=3.6 rtools=3.4.0 r-rjsdmx=2.1_0 r-seasonal=1.8.1
```
Notes about dev_2021:
 - There is a problem with *rstudio* installation. Version 1.1.456, which is the newest currently available in conda, seems too old for this set-up. This causes and erroor and prevents installment of RStudio to `dev_2021`. We might be able to use a standalone installation of RStudio and connect it to this R installation, but this might lead to problems when swithing between R installations (tried using RStudio from different conda environment, this led to R crashing and prevention of RStudio from launhing again). For this reason, before *rstudio* package is updated for Anconda we will not install RStudio to `dev_2021`.

### Jupyter kernel set-up for new environments

Now that a new environment is set up, in order to use the installed newly Python and R versions in Jupyter we need to install *kernels* that tell Jupyter from where to look for the programs. To this end, we specify kernels with unique names so that we can have multiple IPython/IR kernels for different conda environments (see [here](https://ipython.readthedocs.io/en/stable/install/kernel_install.html)).

Run following commands, changing the names depending which environment (`dev_2018` or `dev_2021`) was installed. In the examples in rest of the artcile, we use `dev_2021`.

```
conda activate dev2021
python -m ipykernel install --user --name dev2021_py --display-name "dev2021_py"
R
IRkernel::installspec(name='dev2021_r', displayname='dev2021_r')
quit()
```

This should add two folders under Jupyter kernels directory (typically under *C:\Users\<myusername>\AppData\Roaming\jupyter\kernels*). Check that the folders are created.

### Jupyter kernel set-up for new environments

Finally, run test files to see everything works:

 - python.py (e.g. in VSCode)
 - python.ipynb (in VSCode or Jupyter)
 - R.R (in RStudio installed with environment)
 - R.ipynb (in Jupyter)

See more in section *Using NoobQuant conda environments* below on how to run the examples.

## Using NoobQuant conda environments

In this section we cover tips on how to use the new `conda` environment. No matter where the Python/R instances are run, there are some general tips that one should consider:

 - Make sure Python executable points to one in the new conda environment (check with `import sys; print(sys.executable)`). The path should be something like *~/Anaconda3/envs/<env_name>/python.exe*. Also make sure that Python import paths include the packages directory of the new environment (check with `print(sys.path)`). The path should be something like *~/Anaconda3/envs/dev~*.
 - Make sure R executable points to one in the new conda environment (check with `print(file.path(R.home("bin"))`). The path should be something like *~/Anaconda3/envs/<env_name>/lib/R/bin/x64*. Also make sure R import paths contain **only** the packages directory of the new environment (`print(.libPaths())`). The path should be something like *~/Anaconda3/envs/dev/lib/R/library*. If there are other paths, set `.libPaths()` anew to contain only one path.

**Using Python and R in Jupyter notebooks**

To launch a Python/R instance from the tailored `conda` environment in Jupyter Lab notebook, first select the environment and launch Jupyter Lab:

```
conda activate dev2021
jupyter lab
```

This opens up Jupyter Lab in the browser. If Jupyter kernels of the new environment were correctly set up, they will be visible on the launcher page. Test running *python.ipynb* in a Python `dev2021_py` instance and *R.ipynb* in a Python `dev2021_py` instance. If installation has succeeded, the example should work.

Notice that in *python.ipynb* there are examples on how to leverage package *rpy2* to call R from within Python!

There are some common problems that might arise when running Python or R instances in Jupyter.

- If Jupyter kernel dying/restarting when running rpy2 commands, the reason might be that `R HOME` path is not set and rpy2 does not find the R installation that came with the environment. In this case we need to add it for this particular Python kernel:
  - Find the *kernel.json* for Python Jupyter kernel (e.g. *jupyter/dev2021_py/kernel.json*)
  - Add ```"env": {"R_HOME":"/home/your/anaconda3/envs/my-env-name/lib/R"}```, see [this](https://stackoverflow.com/a/60869259/7037299). Also helpful might be [this](https://stackoverflow.com/questions/39347782/getting-segmentation-fault-core-dumped-error-while-importing-robjects-from-rpy2/53639407#53639407).
- One problem with R Jupyter notebooks might be that if `.libPaths()` contains other paths (from different standalone R versions) that precede the correct one of the conda environment, on notebook loadout wrong packages might be loaded (but not attached) which cannot be reloaded again. This might cause problems with other packages. One solution is to be pedantig about R packages management, not installing packages of any R version into *HOME* path where other versions might pick the packages up.
- Python and R kernels of the new conda environment **should** be accessible in Jupyter when run from `base` environment when explicitly made so, see [here](https://ipython.readthedocs.io/en/stable/install/kernel_install.html) under *"you can make your IPython kernel in one env available to Jupyter in a different env"*. However, I have run to all kinds of problems with the R kernel, e.g. [this](https://github.com/IRkernel/IRkernel/issues/309), [this](https://github.com/jupyter/jupyter/issues/353), and R installation not being found when called from Python instance with *rpy2*. Thus, I have found it easier to use Python and R in Jupyter from *dev* environment. This is why jupyter is also installed in custom environment and not just in `base` as usually suggested (see e.g. discussion [here](https://stackoverflow.com/a/39623487/7037299)). This means whenever I launch Jupyter I make sure to do this from custom environment (e.g. ```conda activate dev2021; jupyter lab```).

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

## Notes about installing environments

- Once environment is ready, one could export environment into construction files that can be used later to spin up the environment. However, building environments from these files does not usually work on different machines (dunno why).
  - (*OS unspecific*): Export *dev* environment to .yml ```conda env export --no-builds > nq_dev_py36_r36.yml``` (why *--no-builds* see [here](https://github.com/ContinuumIO/anaconda-issues/issues/9480)). Remove explicit prefix from end. Then build environment later by ```conda env create --file nq_dev_py36_r36.yml```.
  - (*OS specific*): Export *dev* environment to .txt ```conda list --explicit > nq_dev_py36_r36.txt```. Then build enviroment later by ```conda env create --name dev --file nq_dev_py36_r36.txt```. If error raised try removing line "@EXPLICIT" from the file.

## Useful links
 - https://stackoverflow.com/questions/38066873/create-anaconda-python-environment-with-all-packages
 - https://towardsdatascience.com/a-guide-to-conda-environments-bc6180fc533
 - https://community.rstudio.com/t/why-not-r-via-conda/9438/3
 - https://medium.com/analytics-vidhya/working-on-jupyter-notebooks-in-vs-code-from-virtual-conda-environment-f415726e329d
 - https://www.anaconda.com/blog/moving-conda-environments
