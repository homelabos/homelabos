import axios from "axios";

//class HTTPServer extends axios{
//  http=null;
//  constructor(hostip) {
//    super();
//    this.http=axios.create({
//        baseURL: "http://"+hostip+":8765/",
//        headers: {
//          "Content-type": "application/json",
//          "Access-Control-Allow-Origin": "*"
//        }
//      });
//  }
//}
//export default new HTTPServer();
export default axios.create({
  // baseURL: "http://localhost:3000/api/",
  headers: {
    "Content-type": "application/json",
    "Access-Control-Allow-Origin": "*"
  }
});
