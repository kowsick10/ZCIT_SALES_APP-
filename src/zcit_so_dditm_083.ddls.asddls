@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Item Interface view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCIT_SO_DDITM_083 as select from zcit_so_itm_083
association to parent ZCIT_SO_DD_083 as _salesHeader  
    on $projection.Salesdocument = _salesHeader.Salesdocument
{
    key salesdocument as Salesdocument,
    key salesitemnumber as Salesitemnumber,
    material as Material,
    plant as Plant,
    @Semantics.quantity.unitOfMeasure: 'Quantityunits'
    quantity as Quantity,
    quantityunits as Quantityunits,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt,
    
     /* Associations */ 
    _salesHeader 
}
