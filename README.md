# iOS-UDID
通过Safari与mobileconfig获取iOS设备UDID
通过Safari与mobileconfig获取iOS设备UDID

UDID (Unique Device Identifier)，唯一标示符,是iOS设备的一个唯一识别码，每台iOS设备都有一个独一无二的编码，UDID其实也是在设备量产的时候,生成随机的UUID写入到iOS设备硬件或者某一块存储器中,所以变成了固定的完全不会改变的一个标识，用来区别每一个唯一的iOS设备。

随着苹果对程序内获取UDID封杀的越来越严格,私有api已经获取不到UDID,Mac地址等信息,继而出现了使用钥匙串配合uuid等等方法变相实现

如果你的app是企业应用呢,不需要审核,那么直接用就好了,那要是你的app是需要提交商店的那可能不会审核通过。

 苹果的官方文档是这样介绍的:

https://developer.apple.com/library/content/featuredarticles/iPhoneConfigurationProfileRef/Introduction/Introduction.html#//apple_ref/doc/uid/TP40010206-CH1-SW604

一、通过苹果Safari浏览器获取iOS设备UDID步骤

苹果公司允许开发者通过IOS设备和Web服务器之间的某个操作，来获得IOS设备的UDID(包括其他的一些参数)。这里的一个概述：

1.在你的服务器上创建一个.mobileconfig的XML格式的描述文件；

2.服务器需要的数据，比如：UDID,IMEI需要在.mobileconfig描述文件中配置好，以及服务器接收数据的URL地址；

3.用户在客户端通过某个点击操作完成.mobileconfig描述文件的安装；

4.手机在安装描述文件时，会向描述文件中配置好的URL发送UDID,IMEI等设备信息数据；

5.服务端收到设备信息数据后，通过scheme打开客户端的app将设备信息作为参数传给客户端；

6.客户端在appDelegate里面将 这个参数存到本地 ,并且存到钥匙串,这样即时app被卸载重装,也无需再次安装；

二、.mobileconifg描述文件中配置

<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">



        <key>PayloadContent</key>

        <dict>

            <key>URL</key>

            <string>http://127.0.0.1:6699/receive.do</string>

            <key>DeviceAttributes</key>

            <array>

                <string>SERIAL</string>

                <string>MAC_ADDRESS_EN0</string>

                <string>UDID</string>

                <string>IMEI</string>

                <string>ICCID</string>

                <string>VERSION</string>

                <string>PRODUCT</string>

            </array>

        </dict>

        <key>PayloadOrganization</key>

        <string>dev.aaaaa.org</string>

        <key>PayloadDisplayName</key>

        查询设备UDID

        <key>PayloadVersion</key>

        1

        <key>PayloadUUID</key>

        <string>3C4DC7D2-E475-3375-489C-0BB8D737A653</string>

        <key>PayloadIdentifier</key>

        <string>cn.com.aaaa</string>

        <key>PayloadDescription</key>

        <string>本文件仅用来获取设备ID</string>

        <key>PayloadType</key>

        <string>Profile Service</string>



</plist>

其中,DeviceAttributes对应的key是你想要的信息,还可以添加其他信息,操作系统(iOS)安装完描述文件,获取完这些信息,会将这些信息进行编码,传值给你描述文件中的URL地址，这里需要修改URL就好。

三、服务端

1、mobileconfig下载时设置文件内容类型Content Type为：application/x-apple-aspen-config

2、接口状态码(一般是200),在这里返回状态码301,重定向(必须code码是301(永久性转移),302(暂时性转移)会安装失败)

3.服务器提供接口,然后服务器重定向完之后,将参数 通过scheme打开客户端的app将参数传回来

也可以客户端本地起服务,写一个接口,这里用网上的Server服务器的iOS代码起服务。

