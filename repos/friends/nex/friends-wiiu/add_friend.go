package nex_friends_wiiu
import (
	"github.com/PretendoNetwork/friends/globals"
	nex "github.com/PretendoNetwork/nex-go/v2"
	friends_wiiu "github.com/PretendoNetwork/nex-protocols-go/v2/friends-wiiu"
	"github.com/PretendoNetwork/nex-go/v2/types"
)
func AddFriend(err error, packet nex.PacketInterface, callID uint32, pid *types.PID) (*nex.RMCMessage, *nex.Error) {
	if err != nil {
		globals.Logger.Error(err.Error())
		return nil, nex.NewError(nex.ResultCodes.FPD.InvalidArgument, "")
	}
	rmcResponse := nex.NewRMCSuccess(globals.SecureEndpoint, nil)
	rmcResponse.ProtocolID = friends_wiiu.ProtocolID
	rmcResponse.MethodID = friends_wiiu.MethodAddFriend
	rmcResponse.CallID = callID
	return rmcResponse, nil
}
