//@AbapCatalog.viewEnhancementCategory: [#NONE]
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Item consumption View'
//@Metadata.ignorePropagatedAnnotations: true
//define view entity ZCIT_SO_CNI_083 as select from ZCIT_SO_DDITM_083
//{
//    key Salesdocument,
//    key Salesitemnumber,
//    Material,
//    Plant,
//    Quantity,
//    Quantityunits,
//    LocalCreatedBy,
//    LocalCreatedAt,
//    LocalLastChangedBy,
//    LocalLastChangedAt,
//    LastChangedAt,
//    /* Associations */
//    _salesHeader
//}

 @AccessControl.authorizationCheck: #NOT_REQUIRED 
 @EndUserText.label: 'Sales Order Item Consumption View' 
 @Search.searchable: true 
 @Metadata.ignorePropagatedAnnotations: true 
 @Metadata.allowExtensions: true 
 define view entity ZCIT_SO_CNI_083  
   as projection on ZCIT_SO_DDITM_083
{ 
   key SalesDocument, 
  key SalesItemnumber, 
      @Search.defaultSearchElement: true 
      Material, 
      Plant, 
      @Semantics.quantity.unitOfMeasure: 'Quantityunits' 
      Quantity, 
      Quantityunits, 
      LocalCreatedBy, 
      LocalCreatedAt, 
      LocalLastChangedBy, 
      LocalLastChangedAt, 
       
     /* Associations */ 
      // This links back to the Header Consumption View 
     _salesHeader : redirected to parent ZCIT_SO_CNH_083
     }
