
cd react-ts-vite && npm run build
cd ..
aws s3 sync public s3://zendat --profile fuzztival
aws s3 sync public s3://zendat/kpiDashboard --profile fuzztival


#make build_lambda
make archive_lambda

BUILD_ARCH=`uname -m`
if [ $BUILD_ARCH = "arm64" ];
then
    serverless deploy
else
    serverless deploy -c serverless-x86_64.yml
fi
