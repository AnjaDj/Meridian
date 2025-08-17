-- #############################################################################
-- de1_soc_meridian_top.vhd
-- =====================
--
-- BOARD  : DE1-SoC from Terasic
-- Author : Sahand Kashani-Akhavan from Terasic documentation
-- Revision : 1.7
-- Last updated : 2017-06-11 12:48:26 UTC
--
-- Syntax Rule : GROUP_NAME_N[bit]
--
-- GROUP  : specify a particular interface (ex: SDR_)
-- NAME   : signal name (ex: CONFIG, D, ...)
-- bit    : signal index
-- _N     : to specify an active-low signal
-- #############################################################################

library ieee;
use ieee.std_logic_1164.all;

entity de1_soc_meridian_top is
    port(
        -- CLOCK
        CLOCK_50  : in std_logic;

        -- GPIO_0
        GPIO_0 : inout std_logic_vector(35 downto 0);

        -- GPIO_1
        GPIO_1 : inout std_logic_vector(35 downto 0);

        -- HPS
        HPS_DDR3_ADDR    : out   std_logic_vector(14 downto 0);
        HPS_DDR3_BA      : out   std_logic_vector(2 downto 0);
        HPS_DDR3_CAS_N   : out   std_logic;
        HPS_DDR3_CK_N    : out   std_logic;
        HPS_DDR3_CK_P    : out   std_logic;
        HPS_DDR3_CKE     : out   std_logic;
        HPS_DDR3_CS_N    : out   std_logic;
        HPS_DDR3_DM      : out   std_logic_vector(3 downto 0);
        HPS_DDR3_DQ      : inout std_logic_vector(31 downto 0);
        HPS_DDR3_DQS_N   : inout std_logic_vector(3 downto 0);
        HPS_DDR3_DQS_P   : inout std_logic_vector(3 downto 0);
        HPS_DDR3_ODT     : out   std_logic;
        HPS_DDR3_RAS_N   : out   std_logic;
        HPS_DDR3_RESET_N : out   std_logic;
        HPS_DDR3_RZQ     : in    std_logic;
        HPS_DDR3_WE_N    : out   std_logic;
        HPS_ENET_GTX_CLK : out   std_logic;
        HPS_ENET_INT_N   : inout std_logic;
        HPS_ENET_MDC     : out   std_logic;
        HPS_ENET_MDIO    : inout std_logic;
        HPS_ENET_RX_CLK  : in    std_logic;
        HPS_ENET_RX_DATA : in    std_logic_vector(3 downto 0);
        HPS_ENET_RX_DV   : in    std_logic;
        HPS_ENET_TX_DATA : out   std_logic_vector(3 downto 0);
        HPS_ENET_TX_EN   : out   std_logic;

        HPS_KEY_N        : inout std_logic;
        HPS_LED          : inout std_logic;

        HPS_SD_CLK       : out   std_logic;
        HPS_SD_CMD       : inout std_logic;
        HPS_SD_DATA      : inout std_logic_vector(3 downto 0);

        HPS_UART_RX      : in    std_logic;
        HPS_UART_TX      : out   std_logic
    );
end entity de1_soc_meridian_top;


architecture rtl of de1_soc_meridian_top is

    signal scl0_o       : std_logic;
    signal scl0_o_e     : std_logic;
    signal sda0_o       : std_logic;
    signal sda0_o_e     : std_logic;

    signal spi0_clk     : std_logic;
    signal spi0_mosi    : std_logic;
    signal spi0_miso    : std_logic;
    signal spi0_ss_0_n  : std_logic;

    component soc_system is
        port (
            clk_clk                           : in    std_logic                     := 'X';             -- clk
            hps_0_ddr_mem_a                   : out   std_logic_vector(14 downto 0);                    -- mem_a
            hps_0_ddr_mem_ba                  : out   std_logic_vector(2 downto 0);                     -- mem_ba
            hps_0_ddr_mem_ck                  : out   std_logic;                                        -- mem_ck
            hps_0_ddr_mem_ck_n                : out   std_logic;                                        -- mem_ck_n
            hps_0_ddr_mem_cke                 : out   std_logic;                                        -- mem_cke
            hps_0_ddr_mem_cs_n                : out   std_logic;                                        -- mem_cs_n
            hps_0_ddr_mem_ras_n               : out   std_logic;                                        -- mem_ras_n
            hps_0_ddr_mem_cas_n               : out   std_logic;                                        -- mem_cas_n
            hps_0_ddr_mem_we_n                : out   std_logic;                                        -- mem_we_n
            hps_0_ddr_mem_reset_n             : out   std_logic;                                        -- mem_reset_n
            hps_0_ddr_mem_dq                  : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
            hps_0_ddr_mem_dqs                 : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
            hps_0_ddr_mem_dqs_n               : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
            hps_0_ddr_mem_odt                 : out   std_logic;                                        -- mem_odt
            hps_0_ddr_mem_dm                  : out   std_logic_vector(3 downto 0);                     -- mem_dm
            hps_0_ddr_oct_rzqin               : in    std_logic                     := 'X';             -- oct_rzqin
            
				hps_0_i2c0_scl_in_clk             : in    std_logic                     := 'X';             -- clk
            hps_0_i2c0_clk_clk                : out   std_logic;                                        -- clk
            hps_0_i2c0_out_data               : out   std_logic;                                        -- out_data
            hps_0_i2c0_sda                    : in    std_logic                     := 'X';             -- sda				
				
            hps_0_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
            hps_0_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
            hps_0_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
            hps_0_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
            hps_0_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
            hps_0_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
            hps_0_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
            hps_0_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
            hps_0_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
            hps_0_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
            hps_0_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
            hps_0_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
            hps_0_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
            hps_0_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
            hps_0_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
            hps_0_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
            hps_0_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
            hps_0_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
            hps_0_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
            hps_0_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
            hps_0_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
            hps_0_io_hps_io_uart0_inst_TX     : out   std_logic;                                        -- hps_io_uart0_inst_TX
            hps_0_io_hps_io_gpio_inst_GPIO35  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
            hps_0_io_hps_io_gpio_inst_GPIO53  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
            hps_0_io_hps_io_gpio_inst_GPIO54  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
            hps_0_spim0_txd                   : out   std_logic;                                        -- txd
            hps_0_spim0_rxd                   : in    std_logic                     := 'X';             -- rxd
            hps_0_spim0_ss_in_n               : in    std_logic                     := 'X';             -- ss_in_n
            hps_0_spim0_ssi_oe_n              : out   std_logic;                                        -- ssi_oe_n
            hps_0_spim0_ss_0_n                : out   std_logic;                                        -- ss_0_n
            hps_0_spim0_ss_1_n                : out   std_logic;                                        -- ss_1_n
            hps_0_spim0_ss_2_n                : out   std_logic;                                        -- ss_2_n
            hps_0_spim0_ss_3_n                : out   std_logic;                                        -- ss_3_n
            hps_0_spim0_sclk_out_clk          : out   std_logic                                         -- clk
        );
    end component soc_system;

begin

    u0 : component soc_system
        port map (
            clk_clk                      				=> CLOCK_50,

            hps_0_ddr_mem_a                       	=> HPS_DDR3_ADDR,
            hps_0_ddr_mem_ba                      	=> HPS_DDR3_BA,
            hps_0_ddr_mem_ck                      	=> HPS_DDR3_CK_P,
            hps_0_ddr_mem_ck_n                    	=> HPS_DDR3_CK_N,
            hps_0_ddr_mem_cke                     	=> HPS_DDR3_CKE,
            hps_0_ddr_mem_cs_n                    	=> HPS_DDR3_CS_N,
            hps_0_ddr_mem_ras_n                   	=> HPS_DDR3_RAS_N,
            hps_0_ddr_mem_cas_n                   	=> HPS_DDR3_CAS_N,
            hps_0_ddr_mem_we_n                    	=> HPS_DDR3_WE_N,
            hps_0_ddr_mem_reset_n                 	=> HPS_DDR3_RESET_N,
            hps_0_ddr_mem_dq                      	=> HPS_DDR3_DQ,
            hps_0_ddr_mem_dqs                     	=> HPS_DDR3_DQS_P,
            hps_0_ddr_mem_dqs_n                   	=> HPS_DDR3_DQS_N,
            hps_0_ddr_mem_odt                     	=> HPS_DDR3_ODT,
            hps_0_ddr_mem_dm                      	=> HPS_DDR3_DM,
            hps_0_ddr_oct_rzqin                   	=> HPS_DDR3_RZQ,

            hps_0_i2c0_out_data                         => sda0_o_e,
            hps_0_i2c0_sda                              => sda0_o,

            hps_0_io_hps_io_emac1_inst_TX_CLK     	=> HPS_ENET_GTX_CLK,
            hps_0_io_hps_io_emac1_inst_TXD0       	=> HPS_ENET_TX_DATA(0),
            hps_0_io_hps_io_emac1_inst_TXD1       	=> HPS_ENET_TX_DATA(1),
            hps_0_io_hps_io_emac1_inst_TXD2       	=> HPS_ENET_TX_DATA(2),
            hps_0_io_hps_io_emac1_inst_TXD3       	=> HPS_ENET_TX_DATA(3),
            hps_0_io_hps_io_emac1_inst_RXD0       	=> HPS_ENET_RX_DATA(0),
            hps_0_io_hps_io_emac1_inst_MDIO       	=> HPS_ENET_MDIO,
            hps_0_io_hps_io_emac1_inst_MDC        	=> HPS_ENET_MDC,
            hps_0_io_hps_io_emac1_inst_RX_CTL     	=> HPS_ENET_RX_DV,
            hps_0_io_hps_io_emac1_inst_TX_CTL     	=> HPS_ENET_TX_EN,
            hps_0_io_hps_io_emac1_inst_RX_CLK     	=> HPS_ENET_RX_CLK,
            hps_0_io_hps_io_emac1_inst_RXD1       	=> HPS_ENET_RX_DATA(1),
            hps_0_io_hps_io_emac1_inst_RXD2       	=> HPS_ENET_RX_DATA(2),
            hps_0_io_hps_io_emac1_inst_RXD3       	=> HPS_ENET_RX_DATA(3),

            hps_0_io_hps_io_sdio_inst_CMD         	=> HPS_SD_CMD,
            hps_0_io_hps_io_sdio_inst_D0          	=> HPS_SD_DATA(0),
            hps_0_io_hps_io_sdio_inst_D1          	=> HPS_SD_DATA(1),
            hps_0_io_hps_io_sdio_inst_CLK         	=> HPS_SD_CLK,
            hps_0_io_hps_io_sdio_inst_D2          	=> HPS_SD_DATA(2),
            hps_0_io_hps_io_sdio_inst_D3          	=> HPS_SD_DATA(3),

            hps_0_io_hps_io_uart0_inst_RX         	=> HPS_UART_RX,
            hps_0_io_hps_io_uart0_inst_TX         	=> HPS_UART_TX,

            hps_0_io_hps_io_gpio_inst_GPIO35      	=> HPS_ENET_INT_N,
            hps_0_io_hps_io_gpio_inst_GPIO53      	=> HPS_LED,
            hps_0_io_hps_io_gpio_inst_GPIO54      	=> HPS_KEY_N,
            
            hps_0_spim0_txd                             => spi0_mosi,
            hps_0_spim0_rxd                             => spi0_miso,
            hps_0_spim0_ss_in_n                         => '1',
            hps_0_spim0_ssi_oe_n                        => open,
            hps_0_spim0_ss_0_n                          => spi0_ss_0_n,
            hps_0_spim0_ss_1_n                          => open,
            hps_0_spim0_ss_2_n                          => open,
            hps_0_spim0_ss_3_n                          => open,
            hps_0_spim0_sclk_out_clk                    => spi0_clk,
            hps_0_i2c0_scl_in_clk                       => scl0_o,
            hps_0_i2c0_clk_clk                          => scl0_o_e
        );

        -- SCL linija dodati pull-up od 4.7k - 10k na 3.3V
        GPIO_0(1) <= 'Z' when scl0_o_e = '0' else '0';
        scl0_o    <= GPIO_0(1);

        -- SDA linija dodati pull-up od 4.7k - 10k na 3.3V
        GPIO_0(3) <= 'Z' when sda0_o_e = '0' else '0';  -- HPS šalje '0' kada je OE='1'; inače 'Z'
        sda0_o    <= GPIO_0(3);                         -- čitanje sa linije

        -- SPI clock
        GPIO_0(4) <= spi0_clk;

        -- SPI chip select
        GPIO_0(5) <= spi0_ss_0_n;

        -- MOSI – izlaz iz HPS
        GPIO_0(7) <= spi0_mosi;

        -- MISO – ulaz u HPS
        spi0_miso <= GPIO_0(6);

end;