section Upwork;

stgConfig = try Json.Document(Extension.Contents("config_stg.json"));
prodConfig = Json.Document(Extension.Contents("config.json"));
config = if stgConfig[HasError] then prodConfig else stgConfig[Value];
baseUrl = config[baseUrl];
requestTokenUrl = config[requestTokenUrl];
authenticateUrl = config[authenticateUrl];
clientId = config[clientId];
clientSecret = config[clientSecret];
callbackUrl = config[callbackUrl];
windowWidth = config[windowWidth];
windowHeight = config[windowHeight];
graphQLUrl = config[graphQLUrl];
defaultPageSize = config[defaultPageSize];

Upwork.LoadFunction = (name as text) =>
    let
        binary = Extension.Contents(name),
        asText = Text.FromBinary(binary)
    in
        Expression.Evaluate(asText, #shared);

Upwork.LoadQuery = (path as text) =>
    let
        binary = Extension.Contents(path),
        asText = Text.FromBinary(binary)
    in
        Expression.Evaluate(asText, #shared);


Upwork.getNullSafeElement = (jsonObj as any, keyName as text, keyType as text) =>
    let 
        defaultResult = if  keyType = "LIST" then [] else if  keyType = "OBJECT" then Json.Document("{}") else null,
        result = if jsonObj <> null and Record.HasFields(jsonObj, keyName) and (Record.FieldOrDefault(jsonObj, keyName) <> null) then Record.Field(jsonObj, keyName) else defaultResult
	in
        result;

Upwork.GQLRequest = Upwork.LoadFunction("Upwork.GQLRequest.pqm");

Upwork.QueryCompanySelector = Upwork.LoadQuery("query_company_selector.pqm");
Upwork.QueryContracts = Upwork.LoadQuery("query_contracts.pqm");
Upwork.QueryContractFeedbacks = Upwork.LoadQuery("query_contract_feedback.pqm");
Upwork.QueryContractFreelancers = Upwork.LoadQuery("query_contract_freelancers.pqm");
Upwork.QueryContractJobs = Upwork.LoadQuery("query_contract_jobs.pqm");
Upwork.QueryContractMilestones = Upwork.LoadQuery("query_contract_milestones.pqm");
Upwork.QueryJobPosting = Upwork.LoadQuery("query_job_postings.pqm");
Upwork.ToNavigationTable = Upwork.LoadQuery("Upwork.ToNavigationTable.pqm");
Upwork.QueryOffers = Upwork.LoadQuery("query_offers.pqm");
Upwork.QueryOrganization = Upwork.LoadQuery("query_organization.pqm");
Upwork.QueryCustomFields = Upwork.LoadQuery("query_custom_fields.pqm");
Upwork.QueryAccountingEntity = Upwork.LoadQuery("query_accounting_entity.pqm");
Upwork.QueryTransactionHistory = Upwork.LoadQuery("query_transaction_history.pqm");
Upwork.QueryCompanyStaffs = Upwork.LoadQuery("query_company_staffs.pqm");
Upwork.QueryContractTimeReport = Upwork.LoadQuery("query_contract_time_report.pqm");


[DataSource.Kind="Upwork", Publish="Upwork.Publish"]
shared Upwork.Contents = Upwork.GetAllPages;


Upwork.GetData = (optional _context as any) =>
    let
        context = if _context <> null then _context else [],
        //DATA COLLECTIONS
        Targets = [
        Organizations = Upwork.QueryCompanySelector([f=Upwork.GQLRequest, ctx = context, config = config]),
        Contracts = Upwork.QueryContracts([f=Upwork.GQLRequest, ctx = context, config = config]),
        JobPosting = Upwork.QueryJobPosting([f=Upwork.GQLRequest, ctx = context, config = config]),
        Offers = Upwork.QueryOffers([f=Upwork.GQLRequest, ctx = context, config = config]),
        ContractFeedbacks 	= Upwork.QueryContractFeedbacks([f=Upwork.GQLRequest, ctx = context, config = config]),
        ContractFreelancers = Upwork.QueryContractFreelancers([f=Upwork.GQLRequest, ctx = context, config = config]),
        ContractJobs 		= Upwork.QueryContractJobs([f=Upwork.GQLRequest, ctx = context, config = config]),
        ContractMilestones 	= Upwork.QueryContractMilestones([f=Upwork.GQLRequest, ctx = context, config = config]),
        CustomFields        = Upwork.QueryCustomFields([f=Upwork.GQLRequest, ctx = context, config = config]),
        TransactionHistory = Upwork.QueryTransactionHistory([f=Upwork.GQLRequest, ctx = context, config = config]),
        AccountingEntity = Upwork.QueryAccountingEntity([f=Upwork.GQLRequest, ctx = context, config = config]),
        CompanyStaffs = Upwork.QueryCompanyStaffs([f=Upwork.GQLRequest, ctx = context, config = config]),
        ContractTimeReport = Upwork.QueryContractTimeReport([f=Upwork.GQLRequest, getNullSafeElement=Upwork.getNullSafeElement, ctx = context, config = config]),
        //END DATA COLLECTIONS 
        AsNav = Upwork.GetDataAsNavTable(context)
        ],
        Target = Record.FieldOrDefault(context, "target", null), 
        Records = if Target <> null then Record.Field(Targets, Target) else Targets[AsNav],
        AsRecords = Record.FieldOrDefault(context, "asRecords", null)
    in
        if (AsRecords <> null or Target = null or Target = "AsNav") then
            Records
        else
             Record.ToTable(Records);

Upwork.GetDataAsNavTable = (optional context as any) =>
    let

        Objects = #table(
            {"Name",       "Key",        "Data",                           "ItemKind", "ItemName", "IsLeaf"},
            {
                {"Organizations",      "Organizations",      Upwork.Contents([target="Organizations", sample=true]), "Table",    "Table",    true}
               ,{"Contracts",      "Contracts", Upwork.Contents([target="Contracts", sample=true]), "Table",    "Table",    true}
               ,{"JobPosting",      "JobPosting",      Upwork.Contents([target="JobPosting", sample=true]),  "Table",    "Table",    true} 
               ,{"Contract_Feedbacks",      "ContractFeedbacks",      Upwork.Contents([target="ContractFeedbacks", sample=true]),  "Table",    "Table",    true} 
               ,{"Contract_Freelancers",      "ContractFreelancers",      Upwork.Contents([target="ContractFreelancers", sample=true]),  "Table",    "Table",    true} 
               ,{"Contract_Jobs",      "ContractJobs",      Upwork.Contents([target="ContractJobs", sample=true]),  "Table",    "Table",    true} 
               ,{"CustomFields",      "CustomFields",      Upwork.Contents([target="CustomFields", sample=true]),  "Table",    "Table",    true} 
               ,{"TransactionHistory",      "TransactionHistory",      Upwork.Contents([target="TransactionHistory", sample=true]),  "Table",    "Table",    true} 
               ,{"AccountingEntity",      "AccountingEntity",      Upwork.Contents([target="AccountingEntity", sample=true]),  "Table",    "Table",    true} 
               ,{"CompanyStaffs",      "CompanyStaffs",      Upwork.Contents([target="CompanyStaffs", sample=true]),  "Table",    "Table",    true} 
               ,{"ContractTimeReport",      "ContractTimeReport",  Upwork.Contents([target="ContractTimeReport", sample=true]),  "Table",    "Table",    true} 
            }),
        NavTable = Upwork.ToNavigationTable(Objects, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
       NavTable;


Upwork.GetPage = (previousPageResult as any, optional context as any) as any => 
        let
            _first = Record.FieldOrDefault(previousPageResult, "first", defaultPageSize), 
            _after = Record.FieldOrDefault(previousPageResult, "after", null),
            total = Record.FieldOrDefault(previousPageResult, "totalCount", 0),
            offset = Record.FieldOrDefault(previousPageResult, "offset", null),

            _afterValue = if offset = null and _after <> null then Text.From( Number.From(_after) + _first) else "0",
            firstValue = if offset = null and total <> 0 and Number.From(_afterValue) > total then total - Number.From(_afterValue) else _first,
            afterValue = if offset = null and _after <> null then Text.From( Number.From(_after) + firstValue) else if offset <> null then offset else "0",
            _counter = previousPageResult[counter] + 1,

            sample = Record.FieldOrDefault(context, "sample", false),
            shouldntstop = afterValue = "0" or (not sample and _counter * firstValue <= total) ,

            contextUpdated1 = Record.AddField(context, "first", firstValue),
            contextUpdated2 = Record.AddField(contextUpdated1, "after", afterValue),
            _pageResult = if shouldntstop then Upwork.GetData(contextUpdated2) else null,
            _totalCount = try (Table.SelectRows(_pageResult, each Text.Contains([Name], "totalCount"))){0}[Value] otherwise 100,
            _offset = try (Table.SelectRows(_pageResult, each Text.Contains([Name], "offset"))){0}[Value] otherwise null
        in
            [
                pageResult =  _pageResult ,
                totalCount = _totalCount,
                after = afterValue,
                counter = _counter,
                first= firstValue,
                offset = _offset,
                stop = if shouldntstop then 0 else 1
            ];

Upwork.GetAllPages = (optional _context as any) as any =>
    let
        Target = Record.FieldOrDefault(_context, "target", null), 
        asSinglePage = Record.FieldOrDefault(_context, "asSinglePage", false), 
        result = if  (Target = null or Target = "AsNav" or asSinglePage) then Upwork.GetData(_context) else Upwork.TableGenerateByPage(_context)
    in 
        result;

Upwork.TableGenerateByPage = (optional _context as any) as any =>
    let 
        _listOfPages = List.Generate(
            () => [pageResult = null, totalCount = 0, first=100, counter = 0, after=null, offset=null, stop=0], 
            (r) =>  r[stop]=0,
            (previousPageResult) => Upwork.GetPage(previousPageResult, _context), 
            each [pageResult] 
        ),
        listOfPages = List.RemoveNulls(_listOfPages),
        // concatenate the pages together
        tableOfPages = Table.FromList(listOfPages, Splitter.SplitByNothing(), {"Column1"}),
        firstRow = tableOfPages{0}?,
        dataTable = if (firstRow = null) then
            Table.FromRows({})
        else        
            Value.ReplaceType(
                Table.ExpandTableColumn(tableOfPages, "Column1", Table.ColumnNames(firstRow[Column1])),
                Value.Type(firstRow[Column1])
            )
    in
        // if we didn't get any pages of data, return an empty table
        // otherwise set the table type based on the columns of the first page
        Table.SelectRows(dataTable, each ([Name] = "data"));

// Data Source Kind description
Upwork = [
    TestConnection = (dataSourcePath) => { "Upwork.Contents" },
    Authentication = [
        OAuth=
            [StartLogin=Upwork.StartLogin, 
            FinishLogin=Upwork.FinishLogin,
            Refresh=Upwork.Refresh]
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
Upwork.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://github.com/upwork/powerbi-connector",
    SourceImage = Upwork.Icons,
    SourceTypeImage = Upwork.Icons
];

Upwork.Icons = [
    Icon16 = { Extension.Contents("Upwork16.png"), Extension.Contents("Upwork20.png"), Extension.Contents("Upwork24.png"), Extension.Contents("Upwork32.png") },
    Icon32 = { Extension.Contents("Upwork32.png"), Extension.Contents("Upwork40.png"), Extension.Contents("Upwork48.png"), Extension.Contents("Upwork64.png") }
];


//Generate Token
Upwork.TokenMethod = (grantType, tokenField, code) =>
    let
        queryString = [
            client_id = clientId,
            client_secret = clientSecret,
            grant_type = grantType,
            redirect_uri = callbackUrl
        ],
        queryWithCode = Record.AddField(queryString, tokenField, code),
        token_uri = baseUrl & requestTokenUrl,
        tokenResponse = Web.Contents(token_uri, [
            Content = Text.ToBinary(Uri.BuildQueryString(queryWithCode)),
            Headers = [
                #"Content-type" = "application/x-www-form-urlencoded",
                #"Accept" = "application/json"
            ]
        ]),
        body = Json.Document(tokenResponse),
        result = if (Record.HasFields(body, {"error", "error_description"})) then 
                    error Error.Record(body[error], body[error_description], body)
                 else
                    body
    in
        result;

//Start Login
Upwork.StartLogin = (resourceUrl, state, display) =>
	let
		AuthorizeUrl = baseUrl & authenticateUrl & "?" & Uri.BuildQueryString([
			client_id = clientId,  
			redirect_uri = callbackUrl,
			state = state,
			response_type = "code"
		])
	in
		[
			LoginUri = AuthorizeUrl,
			CallbackUri = callbackUrl,
			WindowHeight = windowHeight,
			WindowWidth = windowWidth,
			Context = null
		];
//Finish Login
Upwork.FinishLogin = (context, callbackUri, state) =>
	   let
			parts = Uri.Parts(callbackUri)[Query],
			result = if (Record.HasFields(parts, {"error", "error_description"})) then 
						    error Error.Record(parts[error], parts[error_description], parts)
						else if(parts[code] = null) then
                            error Error.Record("code is null", parts)
                        else
						 Upwork.TokenMethod("authorization_code", "code", parts[code])

		in
			result;

//Refresh access_token
Upwork.Refresh = (resourceUrl, refresh_token) => 
                Upwork.TokenMethod("refresh_token", "refresh_token", refresh_token);
