$(function () {
  var urlParams = new URLSearchParams(window.location.search);
  var id = urlParams.get('id');

  function loadCountries(selectedId) {
    $.getJSON('../api/system/countries.ashx?action=list', function (data) {
      var html = '';
      for (var i = 0; i < data.length; i++) {
        var selected = selectedId && String(selectedId) === String(data[i].Id) ? ' selected' : '';
        html += '<option value="' + data[i].Id + '"' + selected + '>' + data[i].Name + '</option>';
      }
      $('#EditProvinceCountry').html(html);
    });
  }

  function loadProvince() {
    $.getJSON('../api/system/provinces.ashx?action=get&id=' + id, function (res) {
      if (!res || !res.ok) {
        alert(res && res.message ? res.message : 'Không tìm thấy dữ liệu');
        return;
      }
      $('#ProvinceTitle').text('Cập nhật tỉnh/thành');
      $('#EditProvinceNameVi').val(res.data.NameVi || '');
      $('#EditProvinceNameEn').val(res.data.NameEn || '');
      $('#EditProvinceStatus').val(String(res.data.Status));
      $('#EditProvinceSort').val(res.data.SortOrder || 0);
      loadCountries(res.data.CountryId);
    });
  }

  $('#BtnTranslateProvince').on('click', function () {
    $.post('../api/system/provinces.ashx', {
      action: 'translate',
      nameVi: $('#EditProvinceNameVi').val()
    }, function (res) {
      if (res && res.ok) {
        $('#EditProvinceNameEn').val(res.data.nameEn || '');
      }
    }, 'json');
  });

  $('#BtnSaveProvince').on('click', function () {
    var payload = {
      action: id ? 'update' : 'create',
      id: id,
      countryId: $('#EditProvinceCountry').val(),
      nameVi: $('#EditProvinceNameVi').val(),
      nameEn: $('#EditProvinceNameEn').val(),
      status: $('#EditProvinceStatus').val(),
      sortOrder: $('#EditProvinceSort').val()
    };

    $.post('../api/system/provinces.ashx', payload, function (res) {
      if (res && res.ok) {
        window.location.href = 'provinces.aspx';
      } else {
        alert(res && res.message ? res.message : 'Có lỗi xảy ra');
      }
    }, 'json');
  });

  if (id) {
    loadProvince();
  } else {
    loadCountries();
  }
});
