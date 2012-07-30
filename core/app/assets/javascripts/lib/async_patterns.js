function async (fn) {
    setTimeout(fn, 20);
}


function sometimeWhen (test, then) {
    async(function () {
        if ( test() ) {
            then();
        } else {
            async(arguments.callee);
        }
    });
}