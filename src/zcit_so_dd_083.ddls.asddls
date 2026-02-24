@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCIT_SO_DD_083 as select from zcit_so_hdr_083
composition [0..*] of ZCIT_SO_DDITM_083  as _SALESITEM
{
    key salesdocument as Salesdocument,
    salesdocumenttype as Salesdocumenttype,
    orderreason as Orderreason,
    salesorganization as Salesorganization,
    distributionchannel as Distributionchannel,
    division as Division,
    salesoffice as Salesoffice,
    salesgroup as Salesgroup,
     @Semantics.amount.currencyCode: 'Currency' 
    netprice as Netprice,
    currency as Currency,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt,
    
    _SALESITEM // Make association public
}
