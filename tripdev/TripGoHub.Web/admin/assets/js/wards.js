$(function () {
  var $loading = $('#adminLoading');

  function toggleLoading(isLoading) {
    if (isLoading) {
      $loading.addClass('is-active').attr('aria-hidden', 'false');
    } else {
      $loading.removeClass('is-active').attr('aria-hidden', 'true');
    }
  }

  function renderStatus(value) {
    var num = parseInt(value, 10);
    var isActive = num === 1;
    var label = isActive ? 'Đang hiển thị' : 'Đang ẩn';
    var cls = isActive ? 'tag-success' : 'tag-muted';
    return '<span class="status-tag ' + cls + '">' + label + '</span>';
  }

  var table = $('#tblWards').DataTable({
    serverSide: true,
    processing: true,
    pageLength: 25,
    lengthChange: false,
    searching: false,
    pagingType: 'simple_numbers',
    renderer: 'bootstrap',
    dom: 'rtip',
    language: {
      info: 'Hiển thị _START_ đến _END_ trong tổng _TOTAL_ bản ghi',
      infoEmpty: 'Hiển thị 0 đến 0 trong tổng 0 bản ghi',
      emptyTable: 'Chưa có dữ liệu',
      zeroRecords: 'Không tìm thấy dữ liệu phù hợp',
      processing: 'Đang tải dữ liệu...',
      paginate: {
        previous: 'Trước',
        next: 'Sau'
      }
    },
    ajax: {
      url: '../api/system/wards.ashx',
      data: function (d) {
        d.countryId = $('#WardCountry').val();
        d.provinceId = $('#WardProvince').val();
        d.status = $('#WardStatus').val();
        d.keyword = $('#WardKeyword').val();
      },
      dataSrc: 'data'
    },
    columns: [
      { data: 'Name' },
      { data: 'ProvinceName' },
      { data: 'Status', render: function (data) { return renderStatus(data); } },
      { data: 'SortOrder' },
      {
        data: null,
        render: function (data) {
          return '<a class="btn btn-sm btn-primary" href="ward_edit.aspx?id=' + data.Id + '"><i class="fa-solid fa-pen"></i> Sửa</a> ' +
                 '<button class="btn btn-sm btn-danger delete" data-id="' + data.Id + '"><i class="fa-solid fa-trash"></i> Xóa</button>';
        }
      }
    ]
  });

  table.on('processing.dt', function (e, settings, processing) {
    toggleLoading(processing);
  });

  table.on('page.dt', function () {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  function loadCountries(selectedId) {
    $.getJSON('../api/system/countries.ashx?action=list', function (data) {
      var html = '';
      for (var i = 0; i < data.length; i++) {
        var selected = selectedId && String(selectedId) === String(data[i].Id) ? ' selected' : '';
        html += '<option value="' + data[i].Id + '"' + selected + '>' + data[i].Name + '</option>';
      }
      $('#WardCountry').html(html);
      loadProvinces();
    });
  }

  function loadProvinces(selectedId) {
    var countryId = $('#WardCountry').val();
    if (!countryId) {
      $('#WardProvince').html('');
      table.ajax.reload();
      return;
    }
    $.getJSON('../api/system/provinces.ashx?action=list&countryId=' + countryId, function (data) {
      var html = '<option value="">Tất cả</option>';
      for (var i = 0; i < data.length; i++) {
        var selected = selectedId && String(selectedId) === String(data[i].Id) ? ' selected' : '';
        html += '<option value="' + data[i].Id + '"' + selected + '>' + data[i].Name + '</option>';
      }
      $('#WardProvince').html(html);
      table.ajax.reload();
    });
  }

  $('#BtnWardFilter').on('click', function () {
    table.ajax.reload();
  });

  $('#BtnWardReset').on('click', function () {
    $('#WardStatus').val('');
    $('#WardKeyword').val('');
    $('#WardProvince').val('');
    table.ajax.reload();
  });

  $('#WardCountry').on('change', function () {
    loadProvinces();
  });

  $('#WardProvince').on('change', function () {
    table.ajax.reload();
  });

  $('#WardKeyword').on('keypress', function (e) {
    if (e.which === 13) {
      table.ajax.reload();
    }
  });

  $('#tblWards').on('click', 'button.delete', function () {
    var id = $(this).data('id');
    if (!confirm('Xóa phường/xã này?')) {
      return;
    }

    $.post('../api/system/wards.ashx?action=delete', { id: id }, function (res) {
      if (res.ok) {
        table.ajax.reload();
      } else {
        alert(res.message || 'Có lỗi xảy ra');
      }
    }, 'json');
  });

  loadCountries();
});
