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

  function renderGroup(value) {
    return value ? '<span class="status-tag tag-success">Nhóm</span>' : '<span class="status-tag tag-muted">Link</span>';
  }

  var table = $('#tblMenus').DataTable({
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
      url: '../api/system/admin_menus.ashx',
      type: 'POST',
      data: function (d) {
        d.keyword = $('#AdminMenuKeyword').val();
        d.status = $('#AdminMenuStatus').val();
      },
      dataSrc: 'data'
    },
    columns: [
      { data: 'MenuId' },
      { data: 'ParentTitle' },
      { data: 'Code' },
      { data: 'TitleVi' },
      { data: 'TitleEn' },
      { data: 'SlugVi' },
      { data: 'SlugEn' },
      { data: 'IsGroup', render: function (data) { return renderGroup(data); } },
      { data: 'Status', render: function (data) { return renderStatus(data); } },
      { data: 'SortOrder' },
      {
        data: null,
        orderable: false,
        render: function (data) {
          return '<a class="btn btn-sm btn-primary" href="admin_menu_edit.aspx?id=' + data.MenuId + '"><i class="fa-solid fa-pen"></i> Sửa</a> ' +
                 '<button class="btn btn-sm btn-danger delete" data-id="' + data.MenuId + '"><i class="fa-solid fa-trash"></i> Xóa</button>';
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

  $('#BtnAdminMenuFilter').on('click', function () {
    table.ajax.reload();
  });

  $('#BtnAdminMenuReset').on('click', function () {
    $('#AdminMenuStatus').val('');
    $('#AdminMenuKeyword').val('');
    table.ajax.reload();
  });

  $('#AdminMenuKeyword').on('keypress', function (e) {
    if (e.which === 13) {
      table.ajax.reload();
    }
  });

  $('#tblMenus').on('click', 'button.delete', function () {
    var id = $(this).data('id');
    if (!confirm('Xóa menu này?')) return;
    $.ajax({
      url: '../api/system/admin_menus.ashx',
      type: 'POST',
      data: { action: 'delete', id: id }
    }).done(function (res) {
      if (res && res.ok) {
        table.ajax.reload();
      } else {
        alert(res && res.message ? res.message : 'Có lỗi xảy ra');
      }
    });
  });
});
