$(function () {
  var urlParams = new URLSearchParams(window.location.search);
  var id = urlParams.get('id');

  function loadCountries(selectedId, selectedProvinceId) {
    $.getJSON('../api/system/countries.ashx?action=list', function (data) {
      var html = '';
      for (var i = 0; i < data.length; i++) {
        var selected = selectedId && String(selectedId) === String(data[i].Id) ? ' selected' : '';
        html += '<option value="' + data[i].Id + '"' + selected + '>' + data[i].Name + '</option>';
      }
      $('#EditWardCountry').html(html);
      loadProvinces(selectedProvinceId);
    });
  }

  function loadProvinces(selectedId) {
    var countryId = $('#EditWardCountry').val();
    if (!countryId) {
      $('#EditWardProvince').html('');
      return;
    }
    $.getJSON('../api/system/provinces.ashx?action=list&countryId=' + countryId, function (data) {
      var html = '';
      for (var i = 0; i < data.length; i++) {
        var selected = selectedId && String(selectedId) === String(data[i].Id) ? ' selected' : '';
        html += '<option value="' + data[i].Id + '"' + selected + '>' + data[i].Name + '</option>';
      }
      $('#EditWardProvince').html(html);
    });
  }

  function loadWard() {
    $.getJSON('../api/system/wards.ashx?action=get&id=' + id, function (res) {
      if (!res || !res.ok) {
        alert(res && res.message ? res.message : 'Không tìm thấy dữ liệu');
        return;
      }
      $('#WardTitle').text('Cập nhật phường/xã');
      $('#EditWardNameVi').val(res.data.NameVi || '');
      $('#EditWardNameEn').val(res.data.NameEn || '');
      $('#EditWardStatus').val(String(res.data.Status));
      $('#EditWardSort').val(res.data.SortOrder || 0);
      loadCountries(res.data.CountryId, res.data.ParentId);
    });
  }

  $('#EditWardCountry').on('change', function () {
    loadProvinces();
  });

  $('#BtnTranslateWard').on('click', function () {
    $.post('../api/system/wards.ashx', {
      action: 'translate',
      nameVi: $('#EditWardNameVi').val()
    }, function (res) {
      if (res && res.ok) {
        $('#EditWardNameEn').val(res.data.nameEn || '');
      }
    }, 'json');
  });

  $('#BtnSaveWard').on('click', function () {
    var payload = {
      action: id ? 'update' : 'create',
      id: id,
      countryId: $('#EditWardCountry').val(),
      provinceId: $('#EditWardProvince').val(),
      nameVi: $('#EditWardNameVi').val(),
      nameEn: $('#EditWardNameEn').val(),
      status: $('#EditWardStatus').val(),
      sortOrder: $('#EditWardSort').val()
    };

    $.post('../api/system/wards.ashx', payload, function (res) {
      if (res && res.ok) {
        window.location.href = 'wards.aspx';
      } else {
        alert(res && res.message ? res.message : 'Có lỗi xảy ra');
      }
    }, 'json');
  });

  if (id) {
    loadWard();
  } else {
    loadCountries();
  }
});
