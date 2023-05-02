// Use this file to write queries to test your data connector
let
  //  result = Upwork.Contents([target="TransactionHistory", aceIds_any="[""35613767""]", rangeStart="2022-01-01", rangeEnd="2022-12-31"])
   // result = Upwork.Contents([target="CompanyStaffs"])
    result = Upwork.Contents([target="Contracts", dateRangeStart = "2022-04-07", dateRangeEnd = "2022-04-08"])
    //result = Upwork.Contents([target="ContractJobs"])
//    result = Upwork.Contents([target="ContractFreelancers", startDatePeriod = {"2022-04-07"}, endDatePeriod = {"2022-04-08"}])
 //     result = Upwork.Contents([target="ContractFeedbacks", startDatePeriod = {"2022-04-07"}, endDatePeriod = {"2022-04-08"}])

  
   // result = Upwork.Contents()
    
in
    result