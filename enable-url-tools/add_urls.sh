# CARCAS project at Carleton College
# Script by Erin Watson '24
# April 1, 2024

# This script tells Datalad where all the models are available to download
# It does 3 things:
#   1. Finds all models that don't have a URL attached
#   2. Adds the URL for all those models
#   3. Pushes the commit to Github

# Find models without a URL attached
echo "Looking for models without a URL"
cd /home/dviewers/www/carcas/carcas-models/models

# Declare the array to store model names
models_missing_urls=()

# Loop through each file in the current directory
for file in *
do
    # Get the output of `git annex whereis` for the current file
    git_annex_output=$(git annex whereis "$file")
    # echo $git_annex_output

    # Check if the output contains the string "url"
    if [[ $git_annex_output != *"url"* ]]; then
        # If not found, add the file name to the array
        models_missing_urls+=("$file")
    fi
done

echo "The following models are missing URLs:"
for model in "${models_missing_urls[@]}"; do
  echo "$model"
done

# Add the URLs for these models 
echo "Adding the URLs for these models"

# create a temporary text file with the model names 
cd /home/dviewers/www/carcas/carcas-models/enable-url-tools
# Print "model" to the top of the file
echo "model,model_no_spaces" > temp_models_missing_urls.csv
# Add each element of "models_missing_urls" to the file on a new line
for model in "${models_missing_urls[@]}"; do
  echo "$model,${model// /%20}" >> temp_models_missing_urls.csv
done

cd /home/dviewers/www/carcas/carcas-models/
# enable-url-tools/temp_models_missing_urls.csv is the file with the model names
# 'https://3dviewer.sites.carleton.edu/carcas/carcas-models/{model_no_spaces}' is the link we want to add (replace {model_no_spaces} with an entry from the file, ie one of the files missing a URL)
# 'model/{model}' is the file we want to add the link to (replace {model} with entry from file)
datalad addurls enable-url-tools/temp_models_missing_urls.csv 'https://3dviewer.sites.carleton.edu/carcas/carcas-models/models/{model_no_spaces}' 'model/{model}' --message "Adding URLs for models so that they can be downloaded from the web from the server"







