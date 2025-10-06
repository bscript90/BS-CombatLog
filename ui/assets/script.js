$(document).ready(function () {
    const copyToClipboard = (str) => {
        const el = document.createElement("textarea");
        el.value = str;
        document.body.appendChild(el);
        el.select();
        document.execCommand("copy");
        document.body.removeChild(el);
    };
    window.addEventListener('message', function (event) {
        if (event.data.action == 'copy') {
            var value = event.data.value;
            copyToClipboard(value);
        } else if (event.data.action == 'update') {
            if (event.data.onscreen) {
                $(`#id-${event.data.array.src}`).css({
                    '--left': event.data.left + '%',
                    '--top': event.data.top + '%'
                });
                $(`#id-${event.data.array.src}`).show();
            }else{
                $(`#id-${event.data.array.src}`).hide();
            }
        } else if (event.data.action == 'remove') {
            $(`#${event.data.array.src}`).remove();
        } else if (event.data.action == 'add') {
            var data = event.data.array;
            $(".container").append(`<div class="item" id="id-${data.src}" style="--left: 50%;--top: 30%;display: none;">
            <div class="info">
                <iconify-icon icon="bxs:hourglass" class="timeout" style="display: none;"></iconify-icon>
                <iconify-icon icon="solar:user-block-bold" class="other" style="display: none;"></iconify-icon>
                <iconify-icon icon="line-md:alert-square-twotone-loop" class="crash" style="display: none;"></iconify-icon>
                <iconify-icon icon="mingcute:exit-door-fill" class="normal" style="display: none;"></iconify-icon>
                <div class="description">
                    <div class="playerid">
                        <div class="label">ID:</div> <span>${data.src}</span>
                    </div>
                    <div class="name">
                        <div class="label">Name:</div> <span>${data.name}</span>
                    </div>
                    <div class="reason">
                        <div class="label">Reason:</div> <span>${data.reason}</span>
                    </div>
                    <div class="time">
                        <div class="label">Time:</div> <span>${data.date}</span>
                    </div>
                </div>
            </div>
            <div class="copy"><span>G</span> Copy Information</div>
        </div>`);
            var reason = data.reason;
            if (reason.includes("Timeout")) {
                $(`#id-${data.src} .timeout`).show();
            } else if (reason.includes("Crashed")) {
                $(`#id-${data.src} .crash`).show();
            } else if (reason.includes("Exit")) {
                $(`#id-${data.src} .normal`).show();
            } else {
                $(`#id-${data.src} .other`).show();
            }
        } 
    });
});