# BPCSMETA

1. ZBPC_DIM_APP abap program and SE16 ZVBPC_DIM_ATTR describes BPC Models with Business and Technical Semantic.
They are used to generate ABAP CDS Table Function/Views with Business Semantic on top of BPC Standard Models. 
BPC 11 (BW/4Hana) Standard Models are now aDSO views.

2. ADT Templates for DDLS Data Definition and ABAP Class Templates allow flexible and quick Views / Table Function creation

2.1. ADT>Window>Preferences>Abap Developement>ABAP Templates : 
class: https://github.com/lucodealethea/BPCSMETA/blob/main/ADT_TEMPLATES/ABAP_BPC_CLASS.xml 
method:
2.2. ADT>Window>Preferences>Abap Developement>Data Definition Templates

Those Views/TF are then used in specific UJ_CUSTOM_LOGIC with SQL (minified): for example Flexible Overhead Cost Allocations are made with COS calculation basis, but in some other scenario with Square Meter or Any Other Driver Table/aDSO that relates to Cost Objects.

In order to avoid locks when BPC Web Interface Administration attempt to modify to BPC Models and Dimensions, it is mandatory to drop the $BPCSMETA Package with those views/tf and reimport in the client where BPC Admin Changes are performed.

Next step will be to generate automatically the SQL Framework if any change occured on BPC model, the Class and TF with Code Composer
