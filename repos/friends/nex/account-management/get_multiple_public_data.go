package nex_account_management
import (
	"github.com/PretendoNetwork/friends/globals"
	nex "github.com/PretendoNetwork/nex-go/v2"
	"github.com/PretendoNetwork/nex-go/v2/types"
	account_management "github.com/PretendoNetwork/nex-protocols-go/v2/account-management"
)
func GetMultiplePublicData(err error, packet nex.PacketInterface, callID uint32, lstPrincipals *types.List[*types.PID]) (*nex.RMCMessage, *nex.Error) {
	if err != nil {
		globals.Logger.Error(err.Error())
		return nil, nex.NewError(nex.ResultCodes.Core.InvalidArgument, "")
	}
	rmcResponse := nex.NewRMCSuccess(globals.SecureEndpoint, nil)
	rmcResponse.ProtocolID = account_management.ProtocolID
	rmcResponse.MethodID = account_management.MethodGetMultiplePublicData
	rmcResponse.CallID = callID
	return rmcResponse, nil
}
