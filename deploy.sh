cd react-ts-vite && npm run build
aws s3 sync public  s3://zendat --profile fuzztival


make archive_lambda

BUILD_ARCH=`uname -m`
if [ $BUILD_ARCH = "arm64" ];
then
    serverless deploy
else
    serverless deploy -c serverless-x86_64.yml
fi