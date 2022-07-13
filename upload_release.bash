
# ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## #
# ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # 
#
#           Clesyde builder (c) 2022
#      ___                   __        ____
#     / _ )___  _______ ____/ /__ ____/ __/
#    / _  / _ \/ __/ _ `/ _  / -_) __/ _/  
#   /____/\___/\__/\_,_/\_,_/\__/_/ /_/    
#                                       
#
# ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## #
# ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # ## ### ## # 

#
# TEST VERSIOn Do not use
#


user='clesyde'
repo='version'
token='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'
tag='2022.6.0'
	

command="curl -s -o release.json -w '%{http_code}' \
	 --request POST \
	 --header 'authorization: Bearer ${token}' \
	 --header 'content-type: application/json' \
	 --data '{\"tag_name\": \"${tag}\"}' \
	 https://api.github.com/repos/$user/$repo/releases"


    http_code=`eval $command`
    if [ $http_code == "201" ]; then
        echo "created release:"
        cat release.json
    else
        echo "create release failed with code '$http_code':"
        cat release.json
        echo "command:"
        echo $command
        return 1
    fi


# upload a release file. 
# this must be called only after a successful create_release, as create_release saves 
# the json response in release.json. 
# token: github api user token
# file: path to the asset file to upload 
# name: name to use for the uploaded asset

    token='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'
    file=''
    name=''

    url=`jq -r .upload_url release.json | cut -d{ -f'1'`
    command="\
      curl -s -o upload.json -w '%{http_code}' \
           --request POST \
           --header 'authorization: Bearer ${token}' \
           --header 'Content-Type: application/octet-stream' \
           --data-binary @\"${file}\"
           ${url}?name=${name}"
    http_code=`eval $command`
    if [ $http_code == "201" ]; then
        echo "asset $name uploaded:"
        jq -r .browser_download_url upload.json
    else
        echo "upload failed with code '$http_code':"
        cat upload.json
        echo "command:"
        echo $command
        return 1
    fi
