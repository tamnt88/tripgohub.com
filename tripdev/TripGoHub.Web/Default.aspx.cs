using System;
using System.Configuration;
using System.Data.SqlClient;
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
            var list = new System.Collections.Generic.List<RouteItem>();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["TripGoHubDB"].ConnectionString))
            using (var cmd = new SqlCommand("SELECT RouteId, FromName, ToName FROM dbo.tgh_route WHERE Status = 1 ORDER BY SortOrder, RouteId", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new RouteItem
                        {
                            RouteId = reader.GetInt32(0),
                            FromName = reader.GetString(1),
                            ToName = reader.GetString(2)
                        });
                    }
                }
            }

            var serializer = new JavaScriptSerializer();
            RouteDataJsonHome.Text = serializer.Serialize(list);
        }

        private class RouteItem
        {
            public int RouteId { get; set; }
            public string FromName { get; set; }
            public string ToName { get; set; }
        }
    }
}
