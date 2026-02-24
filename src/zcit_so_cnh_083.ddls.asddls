//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Header Consumption View'
//@Metadata.ignorePropagatedAnnotations: true
//define root view entity ZCIT_SO_CNH_083 as select from ZCIT_SO_DD_083
//composition of target_data_source_name as _association_name
//{
//    key Salesdocument,
//    Salesdocumenttype,
//    Orderreason,
//    Salesorganization,
//    Distributionchannel,
//    Division,
//    Salesoffice,
//    Salesgroup,
//    Netprice,
//    Currency,
//    LocalCreatedBy,
//    LocalCreatedAt,
//    LocalLastChangedBy,
//    LocalLastChangedAt,
//    LastChangedAt,
//    /* Associations */
//    _SALESITEM,
//    _association_name // Make association public
//}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCIT_SO_CNH_083
  provider contract transactional_query
  as projection on ZCIT_SO_DD_083
{
  key SalesDocument,
      SalesDocumentType,
      OrderReason,
      SalesOrganization,
      DistributionChannel,
      Division,
      @Search.defaultSearchElement: true
      SalesOffice,
      SalesGroup,
      @Semantics.amount.currencyCode: 'Currency'
      NetPrice,
      Currency,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,

      /* Associations */
      // This links to the Item Consumption View (which you will create in the next step)
      _salesitem : redirected to composition child ZCIT_SO_CNI_083
}
