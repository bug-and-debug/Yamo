# LOCManagers

Singlton managers for the project basis usage.

## Requirements

iOS 8.0+

## Installation

Add the Locassa iOS components source to your Podfile

	source 'https://bitbucket.org/locassa/specs'

Then you can choose which manager you like to use by adding the following lines to your Podfile:

    pod 'LOCManagers/Device'
    pod 'LOCManagers/Keychain'
    pod 'LOCManagers/Network'
    pod 'LOCManagers/Connectivity'

or you can simply add this line to include all the managers:

	pod 'LOCManagers'

## Available Managers

### Device

Provides convenient methods for detection the system version and the device type.

### Keychain

Provides convenient methods for keychain access.

### Network

Provides methods for API communication. This includes a `LOCApiClient` that you will need to subclass to provide a base URL and provide ideally a block callback that returns a session manager. 

The example code included in the project shows example usage of `LOCApiClient` in the form of `MyLocalApiClient`.

You can probably just copy this and replace the OAuth credentials at the top in your own project or have it injected in the class.

You then use the relevant session mananger in the block for calls.

The sample `MyLocalApiClient` also sample implementation on how you refresh the token of an expire session manager. When session manager hits a 401 status code, it will execute the before try block implementation. You then need to refresh the session manager and pass the new session manager as parameter in the completion block. The API call will be called again with the refresh token.

Beware, the sample `MyLocalApiClient` uses NSUserDefaults to store the refresh tokens. We should be using Keychain. See `LOCKeychain`.

### Connectivity

Provides check for the network connection.