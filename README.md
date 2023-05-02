Introduction 
============
This is the **updated** version of **Power BI Custom Data Connector**
The purpose of this **Power BI Custom Data Connector** is to connect to Upwork API and
pull data related to freelance projects. This custom data connector comes pre-packaged with a **Power BI Report** file to analyze your data quickly.

The connector connects to Upwork APIs using OAuth 2.0 protocol. Make sure you register an OAuth 2.0 client on Upwork before accessing data through this connector.

**Note:** Recommended to use the pre-built, model ready template file "Upwork Report.pbit" under dist folder to pull and visualize data for your account

The connector pulls following data from Upwork API (Note: The data pulled from the connector is limited)

1.  Teams
2.  Jobs (including sub-teams)
3.  Contracts/Engagements
4.  Offers (newly added!)
5.  Freelancers
6.  Billing (Transactions)
7.  Milestones (for active contracts) (newly added!)
8.  Enterprise Custom Fields (newly added!) (fetches only last 3 years contracts CFs)
