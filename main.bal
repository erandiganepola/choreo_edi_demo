import ballerina/io;
import ballerina/http;
import chathurace/edi;

service / on new http:Listener(8080) {

    resource function post convert(http:Request request) returns json|error {
        stream<byte[], io:Error?> byteStream = check request.getByteStream();
        byte[] bytes = [];
        check from byte[] b in byteStream
            do {
                bytes.push(...b);
            };
        string content = check string:fromBytes(bytes);
        io:println(content);

        edi:EDIMapping mapping = check edi:readMappingFromFile("resources/edi-mapping1.json");
        json orderData = check edi:readEDIAsJson(content, mapping);
        io:println(orderData.toJsonString());
        return orderData;
    }
}

