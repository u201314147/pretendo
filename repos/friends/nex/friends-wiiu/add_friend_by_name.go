package nex_friends_wiiu
import (
	"github.com/PretendoNetwork/friends/globals"
	nex "github.com/PretendoNetwork/nex-go/v2"
	friends_wiiu "github.com/PretendoNetwork/nex-protocols-go/v2/friends-wiiu"
	"github.com/PretendoNetwork/nex-go/v2/types"
)
func AddFriendByName(err error, packet nex.PacketInterface, callID uint32, username *types.String) (*nex.RMCMessage, *nex.Error) {
	if err != nil {
		globals.Logger.Error(err.Error())
		return nil, nex.NewError(nex.ResultCodes.FPD.InvalidArgument, "")
	}
	rmcResponse := nex.NewRMCSuccess(globals.SecureEndpoint, nil)
	rmcResponse.ProtocolID = friends_wiiu.ProtocolID
	rmcResponse.MethodID = friends_wiiu.MethodAddFriendByName
	rmcResponse.CallID = callID
	return rmcResponse, nil
}
