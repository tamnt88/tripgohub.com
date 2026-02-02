(function () {
    var tabs = document.querySelectorAll('.search-tabs .tab');
    for (var i = 0; i < tabs.length; i++) {
        tabs[i].addEventListener('click', function () {
            var target = this.getAttribute('data-target');
            for (var j = 0; j < tabs.length; j++) {
                tabs[j].classList.remove('tab--active');
            }
            this.classList.add('tab--active');
            var panels = document.querySelectorAll('.tab-panel');
            for (var k = 0; k < panels.length; k++) {
                panels[k].classList.remove('is-active');
            }
            var panel = document.querySelector(target);
            if (panel) {
                panel.classList.add('is-active');
            }
        });
    }

    function parseRoutes() {
        var holder = document.getElementById('RouteDataJsonHome');
        if (!holder || !holder.value) return [];
        try {
            return JSON.parse(holder.value);
        } catch (e) {
            return [];
        }
    }

    function fillHomeRouteLists() {
        var homeRoutes = parseRoutes();
        var pickupList = document.getElementById('pickupHomeList');
        var dropoffList = document.getElementById('dropoffHomeList');
        if (!pickupList || !dropoffList) return;
        pickupList.innerHTML = '';
        dropoffList.innerHTML = '';
        for (var i = 0; i < homeRoutes.length; i++) {
            var r = homeRoutes[i];
            var opt1 = document.createElement('option');
            opt1.value = r.FromName;
            pickupList.appendChild(opt1);
            var opt2 = document.createElement('option');
            opt2.value = r.ToName;
            dropoffList.appendChild(opt2);
        }
    }

    function buildTransferUrl() {
        var pickup = document.getElementById('PickupHome').value.trim();
        var dropoff = document.getElementById('DropoffHome').value.trim();
        var vehicleType = document.getElementById('VehicleTypeHome').value;
        var tripTypeText = document.getElementById('TripTypeHome').value;
        var tripType = tripTypeText.indexOf('Kh? h?i') >= 0 ? 'round' : 'oneway';
        var query = '?pickup=' + encodeURIComponent(pickup) +
            '&dropoff=' + encodeURIComponent(dropoff) +
            '&trip=' + encodeURIComponent(tripType) +
            '&vehicle=' + encodeURIComponent(vehicleType);
        var baseUrl = '';
        var transferUrl = document.getElementById('TransferBookingUrl');
        if (transferUrl) {
            baseUrl = transferUrl.value || '';
        }
        return baseUrl + query;
    }

    var btn = document.getElementById('BtnFindTransfer');
    if (btn) {
        btn.addEventListener('click', function () {
            window.location.href = buildTransferUrl();
        });
    }

    fillHomeRouteLists();
})();
