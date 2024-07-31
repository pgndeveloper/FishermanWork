-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--( Tunnel )-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
scriptPescador = {}
Tunnel.bindInterface('gn_pescador',scriptPescador)
pescadorCL = Tunnel.getInterface('gn_pescador')
local randompeixe
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--( Funções )------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function scriptPescador.verificaItens() 
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local quantidadeNecessaria = config['Pescaria']['QtdItemIsca']
        local quantidadePlayer = vRP.getInventoryItemAmount(user_id,config['Pescaria']['ItemIsca'])
        if vRP.getInventoryItemAmount(user_id,config['Pescaria']['ItemVaraDePesca']) >= 1 then
            if vRP.getInventoryItemAmount(user_id,config['Pescaria']['ItemIsca']) >= quantidadeNecessaria then
                return true
            else 
                TriggerClientEvent('Notify',source,'aviso',config['Notificações']['SemIsca'][1] .. quantidadeNecessaria-quantidadePlayer .. 'x' .. config['Notificações']['SemIsca'][2])
                return false
            end
        else 
            TriggerClientEvent('Notify',source,'negado',config['Notificações']['SemVara'])
            return false
        end
    end
end

function scriptPescador.verificaRecompensa()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        randompeixe = math.random(#config['Pescaria']['ItensPeixes'])
        if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(config['Pescaria']['ItensPeixes'][randompeixe])*1 <= vRP.getInventoryMaxWeight(user_id) then
            if vRP.tryGetInventoryItem(user_id,config['Pescaria']['ItemIsca'],config['Pescaria']['QtdItemIsca'],false) then
                return true
            end
        else
            TriggerClientEvent('Notify',source,'negado',ldevLeiteiro['Notificações']['MochilaCheia'])
            return false
        end
    end
end

function scriptPescador.recebeRecompensa()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then  
        Wait(config['Pescaria']['TempoProgresso']*1000)
        vRP.giveInventoryItem(user_id,config['Pescaria']['ItensPeixes'][randompeixe],1) 
        randompeixe = nil
    end
end
