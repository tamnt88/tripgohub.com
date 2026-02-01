using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;

namespace TripGoHub.Web.Admin
{
    public partial class AdminMaster : MasterPage
    {
        private const string AdminLang = "vi";
        private string _menuHtml;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session == null || Session["AdminUserId"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            LblUser.Text = "Xin chào, " + (Session["AdminUsername"] ?? "admin");
            _menuHtml = BuildMenuHtml();
        }

        public string GetAdminMenuHtml()
        {
            return _menuHtml ?? string.Empty;
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("login.aspx");
        }

        private string BuildMenuHtml()
        {
            try
            {
                using (var db = new TripGoHubDbContext())
                {
                    var menus = db.AdminMenus.Where(x => x.Status == 1).ToList();
                    if (menus.Count == 0) { return string.Empty; }

                    var lang = db.AdminMenuLang.Where(x => x.Status == 1 && x.Lang == AdminLang).ToList();
                    if (lang.Count == 0) { return string.Empty; }

                    var langMap = lang.GroupBy(x => x.MenuId).ToDictionary(x => x.Key, x => x.First());
                    var currentPath = NormalizeCurrentPath();
                    var lookup = menus.GroupBy(x => x.ParentId ?? 0)
                        .ToDictionary(x => x.Key, x => x.OrderBy(m => m.SortOrder).ThenBy(m => m.Code).ToList());

                    if (!lookup.ContainsKey(0)) { return string.Empty; }

                    var sb = new StringBuilder();
                    foreach (var root in lookup[0])
                    {
                        var rootlang = GetMenuLang(langMap, root.MenuId);
                        if (rootlang == null) continue;

                        var children = lookup.ContainsKey(root.MenuId) ? lookup[root.MenuId] : new List<AdminMenu>();
                        if (root.IsGroup || children.Count > 0)
                        {
                            var isOpen = children.Any(x => IsActiveItem(langMap, x.MenuId, currentPath));
                            var listId = "menuList_" + root.MenuId;
                            sb.Append("<div class=\"menu-group");
                            if (isOpen) sb.Append(" is-open");
                            sb.Append("\">");
                            sb.Append("<button type=\"button\" class=\"menu-toggle\" data-target=\"").Append(listId).Append("\">");
                            sb.Append("<span>");
                            if (!string.IsNullOrWhiteSpace(root.IconClass))
                            {
                                sb.Append("<i class=\"").Append(HttpUtility.HtmlAttributeEncode(root.IconClass)).Append("\"></i> ");
                            }
                            sb.Append(HttpUtility.HtmlEncode(rootlang.Title)).Append("</span>");
                            sb.Append("<i class=\"fa-solid fa-chevron-down\"></i>");
                            sb.Append("</button>");
                            sb.Append("<div class=\"menu-list\" id=\"").Append(listId).Append("\">");
                            foreach (var child in children)
                            {
                                var childlang = GetMenuLang(langMap, child.MenuId);
                                if (childlang == null) continue;
                                sb.Append(BuildMenuItemHtml(child, childlang, currentPath));
                            }
                            sb.Append("</div></div>");
                        }
                        else
                        {
                            sb.Append(BuildMenuItemHtml(root, rootlang, currentPath));
                        }
                    }

                    return sb.ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine("Admin menu error: " + ex);
                return "<!-- admin-menu-error: " + HttpUtility.HtmlEncode(ex.Message) + " -->";
            }
        }

        private AdminMenuLang GetMenuLang(Dictionary<int, AdminMenuLang> map, int menuId)
        {
            AdminMenuLang item;
            return map.TryGetValue(menuId, out item) ? item : null;
        }

        private string BuildMenuItemHtml(AdminMenu menu, AdminMenuLang lang, string currentPath)
        {
            var isActive = IsActiveItem(lang, currentPath);
            var target = string.IsNullOrWhiteSpace(menu.Target) ? string.Empty : " target=\"" + HttpUtility.HtmlAttributeEncode(menu.Target) + "\"";
            
            var href = BuildAdminUrl(lang.Url);

            var sb = new StringBuilder();
            sb.Append("<a href=\"").Append(HttpUtility.HtmlAttributeEncode(href)).Append("\" class=\"menu-item");
            if (isActive) sb.Append(" is-active");
            sb.Append("\"");
            if (!string.IsNullOrWhiteSpace(menu.Target))
            {
                sb.Append(target);
            }
            sb.Append(">");
            if (!string.IsNullOrWhiteSpace(menu.IconClass))
            {
                sb.Append("<i class=\"").Append(HttpUtility.HtmlAttributeEncode(menu.IconClass)).Append("\"></i> ");
            }
            sb.Append(HttpUtility.HtmlEncode(lang.Title));
            sb.Append("</a>");
            return sb.ToString();
        }

        private bool IsActiveItem(Dictionary<int, AdminMenuLang> map, int menuId, string currentPath)
        {
            var lang = GetMenuLang(map, menuId);
            return lang != null && IsActiveItem(lang, currentPath);
        }

        private bool IsActiveItem(AdminMenuLang lang, string currentPath)
        {
            if (string.IsNullOrWhiteSpace(lang.Url)) return false;
            return NormalizeUrl(lang.Url) == currentPath;
        }

        private string NormalizeCurrentPath()
        {
            var path = (Request.AppRelativeCurrentExecutionFilePath ?? string.Empty).ToLowerInvariant();
            if (path.StartsWith("~/admin/"))
            {
                path = path.Substring("~/admin/".Length);
            }
            path = path.TrimStart('/');
            if (path.EndsWith("country_edit.aspx", StringComparison.OrdinalIgnoreCase))
            {
                return "system/countries.aspx";
            }
            if (path.EndsWith("admin_unit_edit.aspx", StringComparison.OrdinalIgnoreCase))
            {
                return "system/admin_units.aspx";
            }
            if (path.EndsWith("province_edit.aspx", StringComparison.OrdinalIgnoreCase))
            {
                return "system/provinces.aspx";
            }
            if (path.EndsWith("ward_edit.aspx", StringComparison.OrdinalIgnoreCase))
            {
                return "system/wards.aspx";
            }
            if (path.EndsWith("admin_menu_edit.aspx", StringComparison.OrdinalIgnoreCase))
            {
                return "system/admin_menus.aspx";
            }
            return path;
        }

        private string NormalizeUrl(string url)
        {
            if (string.IsNullOrWhiteSpace(url)) return string.Empty;
            var value = url.Trim().ToLowerInvariant();
            if (value.StartsWith("~/"))
            {
                value = value.Substring(2);
            }
            if (value.StartsWith("/"))
            {
                value = value.Substring(1);
            }
            if (value.StartsWith("admin/"))
            {
                value = value.Substring("admin/".Length);
            }
            return value;
        }

        private string BuildAdminUrl(string url)
        {
            if (string.IsNullOrWhiteSpace(url)) return "#";
            var value = url.Trim();
            if (value.StartsWith("http://", StringComparison.OrdinalIgnoreCase) ||
                value.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
            {
                return value;
            }

            if (value.StartsWith("~/", StringComparison.OrdinalIgnoreCase) || value.StartsWith("/", StringComparison.OrdinalIgnoreCase))
            {
                return ResolveUrl(value.StartsWith("~", StringComparison.OrdinalIgnoreCase) ? value : "~" + value);
            }

            if (!value.StartsWith("admin/", StringComparison.OrdinalIgnoreCase))
            {
                value = "admin/" + value;
            }

            return ResolveUrl("~/" + value);
        }

    }
}






