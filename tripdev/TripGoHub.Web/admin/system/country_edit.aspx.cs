using System;
using System.Collections.Generic;
using System.Linq;
using TripGoHub.Web.Security;

namespace TripGoHub.Web.Admin.SystemConfig
{
    public partial class CountryEdit : AdminPage
    {
        public List<Language> AdminLanguages { get; private set; }
        public string DefaultLang { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            var langs = LangHelper.GetSupportedLanguages();
            AdminLanguages = langs
                .Where(x => x.LangCode == "vi" || x.LangCode == "en")
                .OrderBy(x => x.SortOrder)
                .ToList();
            var defaultLang = AdminLanguages.FirstOrDefault(x => x.IsDefault);
            DefaultLang = defaultLang != null ? defaultLang.LangCode : "vi";
        }
    }
}
