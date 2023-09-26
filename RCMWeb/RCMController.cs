using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace RCMWeb
{
    [ApiController]
    [Route("~/api/[controller]")]
    public class RCMController : ControllerBase
    {
        string connectionstring = "";
        public class RCMResponse
        {
            public DateTime Date { get; set; }

            public int id { get; set; }


            public string? Description { get; set; }
        }

        [HttpPost(Name = "Login")]
        [Route("Login")]
        public  Task<IEnumerable<RCMResponse>> Login([FromForm] Object Cobj)
        {

            return null;
        }

        [HttpPost(Name = "saveprice")]
        [Route("saveprice")]
        public Task<IEnumerable<RCMResponse>> saveprice( Object Cobj)
        {
            string PriceListdata=Cobj.ToString();
            dynamic PricelistObj = JsonConvert.DeserializeObject(PriceListdata);

            return null;
        }

        public string InsertQueryForPice(dynamic obj)
        {
            dynamic pricelist = Newtonsoft.Json.JsonConvert.DeserializeObject(obj.ToString());
            // var eligType = Authreq.PriorRequest.Authorization.Type;
            //string Query = "insert into " + Elig_auth_table + " (ID,ENTITYID,ENTITYNAME,PRIORREQUESTHEADERSENDERID,PRIORREQUESTHEADERRECEIVERID,PRIORREQUESTHEADERTRANSACTIONDATE,PRIORREQUESTHEADERRECORDCOUNT,PRIORREQUESTHEADERDISPOSITIONFLAG,PRIORREQUESTHEADERPAYERID,PRIORREQUESTAUTHORIZATIONTYPE,PRIORREQUESTAUTHORIZATIONID,PRIORREQUESTAUTHORIZATIONREQUESTTYPE,PRIORREQUESTAUTHORIZATIONGENDER,PRIORREQUESTAUTHORIZATIONMEMBERID,PRIORREQUESTAUTHORIZATIONEMIRATESIDNUMBER,PRIORREQUESTAUTHORIZATIONDATEORDERED,PRIORREQUESTAUTHORIZATIONDATEOFBIRTH,PRIORREQUESTAUTHORIZATIONENCOUNTERFACILITYID,PRIORREQUESTAUTHORIZATIONENCOUNTERTYPE,CREATEDBY,CREATEDATE,UPDATEDBY,UPDATEDATE)";
            //Query += " VALUES ((select NVL(max(id),0) + 1 from elig_auth_request) ";
            //Query += "  ,'" + eligreq.PriorRequest.Authorization.ID + "'";
            //Query += "  ,'" + reqtype + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Header.SenderID + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Header.ReceiverID + "'";
            //Query += "  ,to_date('" + eligreq.PriorRequest.Authorization.DateOrdered + "', 'DD/MM/YYYY hh24:mi')";
            //Query += "  ,'" + eligreq.PriorRequest.Header.RecordCount + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Header.DispositionFlag + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Header.PayerID + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Authorization.Type + "'";

            //Query += "  ,'" + eligreq.PriorRequest.Authorization.ID + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Authorization.RequestType + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Authorization.Gender + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Authorization.MemberID + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Authorization.EmiratesIDNumber + "'";
            //Query += "  ,to_date('" + eligreq.PriorRequest.Authorization.DateOrdered + "', 'DD/MM/YYYY hh24:mi')";
            //Query += "  ,to_date('" + eligreq.PriorRequest.Authorization.DateOfBirth + "', 'DD/MM/YYYY hh24:mi')";
            //Query += "  ,'" + eligreq.PriorRequest.Authorization.Encounter.FacilityID + "'";
            //Query += "  ,'" + eligreq.PriorRequest.Authorization.Encounter.Type + "'";
            //Query += "  ,'OL Server'";
            //Query += "  , to_date(to_char(sysdate,'DD/MM/YYYY HH:MI'), 'DD/MM/YYYY hh24:mi:ss')";
            //Query += "  ,'OL SERVER'";
            //Query += "  ,to_date(to_char(sysdate,'DD/MM/YYYY HH:MI'), 'DD/MM/YYYY hh24:mi:ss'))";
            //var res = InsertData(Query);
            return "";

        }
        public int InsertData(string insertQuery)
        {
            int res = 0;
            using (System.Data.Common.DbConnection connection = new System.Data.OracleClient.OracleConnection(connectionstring))
            {
                connection.Open();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = insertQuery;// "insert into riayati_response (ID,ENTITYID)  values ((select NVL(max(id),0) + 1 from riayati_response),'" + 123 + "')";
                    res = command.ExecuteNonQuery();
                }
            }
            return res;
        }


        [HttpGet(Name = "test")]
        [Route("test")]
        public string Index()
        {
            return "This is my default action...";
        }


        [HttpGet(Name = "GetRCMAPI")]
        [Route("GetRCMAPI")]
        public IEnumerable<RCMResponse> Get()
        {
            RCMResponse obj = new RCMResponse();
            obj.Date = DateTime.Now;
            obj.Description = "Success";

            obj.id = 101;



            string output = "Welcome to the User";

            return Enumerable.Range(1, 1).Select(index => new RCMResponse
            {
                Date = DateTime.Now.AddDays(index),
                Description = "Success",
                id = 10
            })
            .ToArray();

        }


    }
}
