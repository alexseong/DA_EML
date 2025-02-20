#!/bin/bash

CONDA_ENV_NAME=$1
AUTOML_ENV_FILE=$2
PIP_NO_WARN_SCRIPT_LOCATION=0

if [ "$CONDA_ENV_NAME" == "" ]
then
  CONDA_ENV_NAME="azure_automl"
fi

if [ "$AUTOML_ENV_FILE" == "" ]
then
  AUTOML_ENV_FILE="automl_env_mac.yml"
fi

if [ ! -f $AUTOML_ENV_FILE ]; then
    echo "File $AUTOML_ENV_FILE not found"
    exit 1
fi

if source activate $CONDA_ENV_NAME 2> /dev/null
then
   echo "Upgrading azureml-sdk[automl,notebooks,explain] in existing conda environment" $CONDA_ENV_NAME
   pip install --upgrade azureml-sdk[automl,notebooks,explain]
else
   conda env create -f $AUTOML_ENV_FILE -n $CONDA_ENV_NAME &&
   source activate $CONDA_ENV_NAME &&
   conda install lightgbm -c conda-forge -y &&
   python -m ipykernel install --user --name $CONDA_ENV_NAME --display-name "Python ($CONDA_ENV_NAME)" &&
   jupyter nbextension install --py azureml.widgets --user &&
   jupyter nbextension enable --py azureml.widgets --user &&
   pip install numpy==1.15.3
   echo "" &&
   echo "" &&
   echo "***************************************" &&
   echo "* AutoML setup completed successfully *" &&
   echo "***************************************" &&
   echo "" &&
   echo "Starting jupyter notebook - please run the configuration notebook" &&
   echo "" &&
   jupyter notebook --log-level=50
fi

if [ $? -gt 0 ]
then
   echo "Installation failed"
fi



