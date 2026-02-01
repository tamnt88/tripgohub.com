$(function () {
  var urlParams = new URLSearchParams(window.location.search);
  var id = urlParams.get('id');

  function loadCountry() {
    $.getJSON('../api/system/countries.ashx?action=get&id=' + id, function (res) {
      if (!res || !res.ok) {
        alert(res && res.message ? res.message : 'Không tìm thấy dữ liệu');
        return;
      }
      $('#CountryTitle').text('Cập nhật quốc gia');
      $('#CountryIso2').val(res.data.Iso2 || '');
      $('#CountryNameVi').val(res.data.NameVi || '');
      $('#CountryNameEn').val(res.data.NameEn || '');
      $('#CountryStatus').val(String(res.data.Status));
      $('#CountrySort').val(res.data.SortOrder || 0);
    });
  }

  $('#BtnTranslateCountry').on('click', function () {
    $.post('../api/system/countries.ashx', {
      action: 'translate',
      nameVi: $('#CountryNameVi').val()
    }, function (res) {
      if (res && res.ok) {
        $('#CountryNameEn').val(res.data.nameEn || '');
      }
    }, 'json');
  });

  $('#BtnSaveCountry').on('click', function () {
    var payload = {
      action: id ? 'update' : 'create',
      id: id,
      iso2: $('#CountryIso2').val(),
      nameVi: $('#CountryNameVi').val(),
      nameEn: $('#CountryNameEn').val(),
      status: $('#CountryStatus').val(),
      sortOrder: $('#CountrySort').val()
    };

    $.post('../api/system/countries.ashx', payload, function (res) {
      if (res && res.ok) {
        window.location.href = 'countries.aspx';
      } else {
        alert(res && res.message ? res.message : 'Có lỗi xảy ra');
      }
    }, 'json');
  });

  if (id) {
    loadCountry();
  }
});
