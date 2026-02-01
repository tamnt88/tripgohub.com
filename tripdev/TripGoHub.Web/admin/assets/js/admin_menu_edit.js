$(function () {
  var urlParams = new URLSearchParams(window.location.search);
  var id = urlParams.get('id');

  function loadParents(selectedId) {
    $.getJSON('../api/system/admin_menus.ashx', { action: 'parents' }, function (res) {
      var $select = $('#MenuParent');
      $select.find('option:not(:first)').remove();
      if (res && res.data) {
        res.data.forEach(function (item) {
          var selected = selectedId && String(selectedId) === String(item.MenuId) ? ' selected' : '';
          $select.append('<option value="' + item.MenuId + '"' + selected + '>' + item.Title + '</option>');
        });
      }
    });
  }

  function fillForm(data) {
    $('#MenuParent').val(data.ParentId || '');
    $('#MenuCode').val(data.Code || '');
    $('#MenuTitleVi').val(data.TitleVi || '');
    $('#MenuTitleEn').val(data.TitleEn || '');
    $('#MenuUrlVi').val(data.UrlVi || '');
    $('#MenuUrlEn').val(data.UrlEn || '');
    $('#MenuSlugVi').val(data.SlugVi || '');
    $('#MenuSlugEn').val(data.SlugEn || '');
    $('#MenuSeoTitleVi').val(data.SeoTitleVi || '');
    $('#MenuSeoTitleEn').val(data.SeoTitleEn || '');
    $('#MenuSeoDescVi').val(data.SeoDescVi || '');
    $('#MenuSeoDescEn').val(data.SeoDescEn || '');
    $('#MenuSeoKeywordsVi').val(data.SeoKeywordsVi || '');
    $('#MenuSeoKeywordsEn').val(data.SeoKeywordsEn || '');
    $('#MenuIcon').val(data.IconClass || '');
    $('#MenuIsGroup').val(data.IsGroup ? '1' : '0');
    $('#MenuTarget').val(data.Target || '');
    $('#MenuStatus').val(String(data.Status));
    $('#MenuSort').val(data.SortOrder || 0);
  }

  function loadMenu() {
    $.getJSON('../api/system/admin_menus.ashx', { action: 'get', id: id }, function (res) {
      if (!res || !res.ok) {
        alert(res && res.message ? res.message : 'Không tìm thấy dữ liệu');
        return;
      }
      $('#AdminMenuTitle').text('Cập nhật menu admin');
      fillForm(res.data);
      loadParents(res.data.ParentId);
    });
  }

  $('#BtnTranslateEn').on('click', function () {
    $.ajax({
      url: '../api/system/admin_menus.ashx',
      type: 'POST',
      data: {
        action: 'translate',
        titleVi: $('#MenuTitleVi').val(),
        seoTitleVi: $('#MenuSeoTitleVi').val(),
        seoDescVi: $('#MenuSeoDescVi').val(),
        seoKeywordsVi: $('#MenuSeoKeywordsVi').val()
      }
    }).done(function (res) {
      if (res && res.data) {
        $('#MenuTitleEn').val(res.data.titleEn || '');
        $('#MenuSeoTitleEn').val(res.data.seoTitleEn || '');
        $('#MenuSeoDescEn').val(res.data.seoDescEn || '');
        $('#MenuSeoKeywordsEn').val(res.data.seoKeywordsEn || '');
      }
    });
  });

  $('#BtnSaveMenu').on('click', function () {
    var payload = {
      action: id ? 'update' : 'create',
      id: id,
      parentId: $('#MenuParent').val(),
      code: $('#MenuCode').val(),
      titleVi: $('#MenuTitleVi').val(),
      titleEn: $('#MenuTitleEn').val(),
      urlVi: $('#MenuUrlVi').val(),
      urlEn: $('#MenuUrlEn').val(),
      slugVi: $('#MenuSlugVi').val(),
      slugEn: $('#MenuSlugEn').val(),
      seoTitleVi: $('#MenuSeoTitleVi').val(),
      seoTitleEn: $('#MenuSeoTitleEn').val(),
      seoDescVi: $('#MenuSeoDescVi').val(),
      seoDescEn: $('#MenuSeoDescEn').val(),
      seoKeywordsVi: $('#MenuSeoKeywordsVi').val(),
      seoKeywordsEn: $('#MenuSeoKeywordsEn').val(),
      iconClass: $('#MenuIcon').val(),
      isGroup: $('#MenuIsGroup').val(),
      target: $('#MenuTarget').val(),
      status: $('#MenuStatus').val(),
      sortOrder: $('#MenuSort').val()
    };

    $.ajax({
      url: '../api/system/admin_menus.ashx',
      type: 'POST',
      data: payload
    }).done(function (res) {
      if (res && res.ok) {
        window.location.href = 'admin_menus.aspx';
      } else {
        alert(res && res.message ? res.message : 'Có lỗi xảy ra');
      }
    });
  });

  loadParents();

  if (id) {
    loadMenu();
  }
});
