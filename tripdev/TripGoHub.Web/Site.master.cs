using System;
using System.Linq;
using System.Web;
using System.Collections.Generic;

namespace TripGoHub.Web
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        public string CurrentLang { get; private set; }
        public string LangUrlVi { get; private set; }
        public string LangUrlEn { get; private set; }
        public string TransferBookingUrl { get; private set; }
        public string HomeUrl { get; private set; }
        public List<Language> SupportedLanguages { get; private set; }
        public List<PublicMenuLang> PublicMenuItems { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            var lang = LangHelper.GetCurrentLang(Request);
            CurrentLang = lang;
            LangHelper.SaveLangCookie(Response, lang);
            SupportedLanguages = LangHelper.GetSupportedLanguages();

            LangUrlVi = LangHelper.BuildLangUrl(Request, "vi");
            LangUrlEn = LangHelper.BuildLangUrl(Request, "en");
            TransferBookingUrl = LangHelper.BuildLangPath(CurrentLang, "transfer/booking");
            HomeUrl = LangHelper.BuildLangPath(CurrentLang, "/");

            LoadPublicMenu();
        }

        private void LoadPublicMenu()
        {
            PublicMenuItems = new List<PublicMenuLang>();
            try
            {
                using (var db = new TripGoHubDbContext())
                {
                    var menus = db.PublicMenus.Where(x => x.Status == 1)
                        .OrderBy(x => x.SortOrder)
                        .ThenBy(x => x.MenuId)
                        .ToList();

                    if (menus.Count == 0) return;

                    var menuIds = menus.Select(x => x.MenuId).ToList();
                    var langs = db.PublicMenuLang.Where(x => menuIds.Contains(x.MenuId) && x.Lang == CurrentLang && x.Status == 1)
                        .OrderBy(x => x.SortOrder)
                        .ThenBy(x => x.MenuId)
                        .ToList();

                    var map = langs.GroupBy(x => x.MenuId).ToDictionary(x => x.Key, x => x.First());
                    foreach (var menu in menus)
                    {
                        if (map.ContainsKey(menu.MenuId))
                        {
                            PublicMenuItems.Add(map[menu.MenuId]);
                        }
                    }
                }
            }
            catch
            {
            }
        }
    }
}
