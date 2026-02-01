$(function () {
  function getLang() {
    return $('#AdminUnitLang').val() || 'vi';
  }

  function toggleTranslateButton() {
    var lang = getLang();
    $('#TreeLangLabel').text(lang.toUpperCase());
    if (lang === 'en') {
      $('#BtnTranslateAdminUnit').show();
    } else {
      $('#BtnTranslateAdminUnit').hide();
    }
  }

  var selectedNodeId = null;

  function loadCountries() {
    $.getJSON('../api/system/countries.ashx?action=list', function (data) {
      var html = '<option value="">Tất cả</option>';
      var selectedId = '';
      for (var i = 0; i < data.length; i++) {
        if (!selectedId && data[i].Iso2 && data[i].Iso2.toUpperCase() === 'VN') {
          selectedId = data[i].Id;
        }
        html += '<option value="' + data[i].Id + '">' + data[i].Name + '</option>';
      }
      $('#TreeCountry').html(html);
      if (selectedId) {
        $('#TreeCountry').val(String(selectedId));
      }
      loadTree();
    });
  }

  function loadTree() {
    var countryId = $('#TreeCountry').val();
    $('#adminUnitTree').jstree('destroy');
    $('#adminUnitTree').jstree({
      core: {
        data: {
          url: '../api/system/admin_units.ashx?action=tree&countryId=' + countryId + '&lang=' + getLang(),
          dataType: 'json'
        },
        themes: { dots: true }
      },
      plugins: ['search', 'wholerow']
    }).on('select_node.jstree', function (e, data) {
      selectedNodeId = data.node.id;
      var meta = data.node.data || {};
      $('#SelectedParent').val(data.node.text);
      if (meta.levelType) {
        $('#AdminUnitLevel').val(meta.levelType);
      }
      if (meta.status !== undefined) {
        $('#AdminUnitStatus').val(String(meta.status));
      }
      if (meta.sortOrder !== undefined) {
        $('#AdminUnitSort').val(String(meta.sortOrder));
      }
      if (meta.name) {
        $('#AdminUnitName').val(meta.name);
      }
    });
  }

  var to = false;
  $('#TreeSearch').on('keyup', function () {
    if (to) { clearTimeout(to); }
    to = setTimeout(function () {
      var v = $('#TreeSearch').val();
      $('#adminUnitTree').jstree(true).search(v);
    }, 300);
  });

  $('#TreeCountry').on('change', function () {
    selectedNodeId = null;
    $('#SelectedParent').val('');
    $('#AdminUnitName').val('');
    loadTree();
  });

  $('#AdminUnitLang').on('change', function () {
    toggleTranslateButton();
    loadTree();
  });

  $('#BtnTranslateAdminUnit').on('click', function () {
    $.post('../api/system/admin_units.ashx?action=translate', {
      nameVi: $('#AdminUnitName').val()
    }, function (res) {
      if (res && res.ok) {
        $('#AdminUnitName').val(res.data.nameEn || '');
      }
    }, 'json');
  });

  $('#BtnSaveAdminUnit').on('click', function () {
    $.post('../api/system/admin_units.ashx?action=create', {
      countryId: $('#TreeCountry').val(),
      parentId: selectedNodeId,
      levelType: $('#AdminUnitLevel').val(),
      name: $('#AdminUnitName').val(),
      status: $('#AdminUnitStatus').val(),
      sortOrder: $('#AdminUnitSort').val(),
      lang: getLang()
    }, function (res) {
      if (res.ok) {
        loadTree();
      } else {
        alert(res.message || 'Có lỗi xảy ra');
      }
    }, 'json');
  });

  $('#BtnUpdateAdminUnit').on('click', function () {
    if (!selectedNodeId) {
      alert('Chọn một đơn vị để cập nhật');
      return;
    }
    $.post('../api/system/admin_units.ashx?action=update', {
      id: selectedNodeId,
      countryId: $('#TreeCountry').val(),
      parentId: null,
      levelType: $('#AdminUnitLevel').val(),
      name: $('#AdminUnitName').val(),
      status: $('#AdminUnitStatus').val(),
      sortOrder: $('#AdminUnitSort').val(),
      lang: getLang()
    }, function (res) {
      if (res.ok) {
        loadTree();
      } else {
        alert(res.message || 'Có lỗi xảy ra');
      }
    }, 'json');
  });

  $('#BtnDeleteAdminUnit').on('click', function () {
    if (!selectedNodeId) {
      alert('Chọn một đơn vị để xóa');
      return;
    }
    if (!confirm('Xóa đơn vị này?')) {
      return;
    }
    $.post('../api/system/admin_units.ashx?action=delete', { id: selectedNodeId }, function (res) {
      if (res.ok) {
        selectedNodeId = null;
        $('#SelectedParent').val('');
        $('#AdminUnitName').val('');
        loadTree();
      } else {
        alert(res.message || 'Có lỗi xảy ra');
      }
    }, 'json');
  });

  toggleTranslateButton();
  loadCountries();
});
