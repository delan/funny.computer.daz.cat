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
