using System;
using System.Linq;
using System.Web.Script.Serialization;

namespace TripGoHub.Web
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            BindRouteJson();
            BindTransferUrl();
        }

        private void BindRouteJson()
        {
            var lang = LangHelper.GetCurrentLang(Request);

            using (var db = new TripGoHubDbContext())
            {
                var routes = db.Routes.Where(x => x.Status == 1)
                    .OrderBy(x => x.SortOrder)
                    .ThenBy(x => x.RouteId)
                    .ToList();

                var routeIds = routes.Select(x => x.RouteId).ToList();
                var i18nMap = db.RouteLang.Where(x => routeIds.Contains(x.RouteId) && x.Lang == lang)
                    .ToList()
                    .GroupBy(x => x.RouteId)
                    .ToDictionary(x => x.Key, x => x.First());

                var list = routes.Select(x =>
                {
                    var name = i18nMap.ContainsKey(x.RouteId) ? i18nMap[x.RouteId] : null;
                    return new RouteItem
                    {
                        RouteId = x.RouteId,
                        FromName = name != null ? name.FromName : x.FromName,
                        ToName = name != null ? name.ToName : x.ToName
                    };
                }).ToList();

                var serializer = new JavaScriptSerializer();
                RouteDataJsonHome.Value = serializer.Serialize(list);
            }
        }

        private void BindTransferUrl()
        {
            var master = Master as TripGoHub.Web.SiteMaster;
            if (master != null)
            {
                TransferBookingUrl.Value = master.TransferBookingUrl;
            }
        }

        private class RouteItem
        {
            public int RouteId { get; set; }
            public string FromName { get; set; }
            public string ToName { get; set; }
        }
    }
}

