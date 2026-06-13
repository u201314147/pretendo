package nex_account_management
import (
	"github.com/PretendoNetwork/friends/globals"
	nex "github.com/PretendoNetwork/nex-go/v2"
	account_management "github.com/PretendoNetwork/nex-protocols-go/v2/account-management"
)
func GetAccountData(err error, packet nex.PacketInterface, callID uint32) (*nex.RMCMessage, *nex.Error) {
	if err != nil {
		globals.Logger.Error(err.Error())
		return nil, nex.NewError(nex.ResultCodes.Core.InvalidArgument, "")
	}
	rmcResponse := nex.NewRMCSuccess(globals.SecureEndpoint, nil)
	rmcResponse.ProtocolID = account_management.ProtocolID
	rmcResponse.MethodID = account_management.MethodGetAccountData
	rmcResponse.CallID = callID
	return rmcResponse, nil
}
