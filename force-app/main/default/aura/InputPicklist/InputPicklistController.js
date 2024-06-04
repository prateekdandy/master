({
    doInit: function (component, event, helper) {

        helper.callAction( component, 'c.getFieldLabel', {
            'objectName' : component.get('v.Sobject'),
            'fieldName'  : component.get('v.SoField')
        }, function( data ) {
            component.set('v.label', data);
        });

        helper.callAction( component, 'c.getPicklistOptions', {
            'objectName' : component.get('v.Sobject'),
            'fieldName'  : component.get('v.SoField')
        }, function( data ) {
            component.set('v.Soptions', data);
        });

    },
    handleChange: function (component, event, helper) {
        component.set('v.field',event.getParam("value"));

    }
})