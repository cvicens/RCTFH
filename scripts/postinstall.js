// just verify if is running on OS X and call COCOAPods to install frameworks/library deps
const isOsX = /^darwin/.test(process.platform);

var doPodInstall = function(){
    let
        spawn = require( 'child_process' ).spawn,
        podInstall = spawn( 'pod', [ 'install' ] );

    podInstall.stdout.on( 'data', data => {
        console.log( `podInstall stdout: ${data}` );
    });

    podInstall.stderr.on( 'data', data => {
        console.log( `podInstall stderr: ${data}` );
    });

    podInstall.on( 'close', code => {
        console.log( `podInstall child process exited with code ${code}` );
    });
};

if (isOsX){
    console.log('Yep! I am in an Apple OS X...');
    let
        spawn = require( 'child_process' ).spawn,
        hasCocoapods = spawn( 'gem', [ 'list', '-i', 'cocoapods' ] );

    hasCocoapods.stdout.on( 'data', data => {
        console.log( `hasCocoapods stdout: ${data}` );

        //has cocoapods gem installed?
        if (eval(`${data}`)){
            console.log('installing frameworks dependencias using cocoapods...');
            doPodInstall();
        }
        else{
            console.log('Gem Cocoapods not present!');
        }
    });

    hasCocoapods.stderr.on( 'data', data => {
        console.log( `hasCocoapods stderr: ${data}` );
    });

    hasCocoapods.on( 'close', code => {
        console.log( `hasCocoapods child process exited with code ${code}` );
    });
}
