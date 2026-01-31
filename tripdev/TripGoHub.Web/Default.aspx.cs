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
        }

        private void BindRouteJson()
        {
            using (var db = new TripGoHubDbContext())
            {
                var list = db.Routes.Where(x => x.Status == 1)
                    .OrderBy(x => x.SortOrder)
                    .ThenBy(x => x.RouteId)
                    .Select(x => new RouteItem
                    {
                        RouteId = x.RouteId,
                        FromName = x.FromName,
                        ToName = x.ToName
                    })
                    .ToList();

                var serializer = new JavaScriptSerializer();
                RouteDataJsonHome.Text = serializer.Serialize(list);
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
