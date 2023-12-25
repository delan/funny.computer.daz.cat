// 88x31 for those who prefer reduced motion
// • hover to play animated gif, unhover to pause
// • compatible with netscape 4+ and ie 5+ (4+?)
// • usage: <img src=".../paused/.../foo.gif">
//     • paused version goes in .../paused/.../foo.gif
//     • animated version goes in .../.../foo.gif

for (var i = 0; i < document.images.length; i++) {
    var image = document.images[i];
    if (image.src.lastIndexOf("/paused/") == image.src.lastIndexOf("/") - "/paused".length) {
        image.onmouseover = function() {
            var stop = this.src.lastIndexOf("/paused/");
            var start = this.src.lastIndexOf("/");
            this.src = this.src.substring(0,stop) + this.src.substring(start);
        };
        image.onmouseout = function() {
            var index = this.src.lastIndexOf("/");
            this.src = this.src.substring(0,index) + "/paused" + this.src.substring(index);
        };
    }
}
