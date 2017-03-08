document.addEventListener("deviceready", yourCallbackFunction, false);
function testClick(){
    Cordova.exec(successFunction, failFunction, "TestPlugin", "testMethod", ["回调方法"]);
}
function successFunction(){
    alert("successFunction");
}
function failFunction(){
    alert("failFunction");
}