$(function(){
    $(".user-setting li").click(function(){
        $(".user-setting li").removeClass("active");
        $(this).addClass("active");
        var panelId = "#"+$(this).attr("name");
        $("#userPanel > div").css({'display':'none'});
        $(panelId).css({'display':'block'});

    });
    //提交试卷start
    $("#uploadTestPaper").on("click", function() {
        _this = this; //this是事件源
        $("#confirmUpload").modal("show");
    });

    $(".confirmUploadTestPaper").on("click", function() {
        $("#confirmUpload").modal("hide");
    });
    //提交试卷end

    //考生注册start
    $(".studentRegisteredConfirm").on("click", function() {
        $("#studentRegisteredSuccess").modal("hide");
    });

    $(".studentRegisteredConfirm").on("click", function() {
        $("#studentRegisteredFailure").modal("hide");
    });
    $(".studentRegisteredFailConfirm").on("click", function() {
        $("#studentRegisteredFailure").modal("hide");
    });
    //考生注册end
});